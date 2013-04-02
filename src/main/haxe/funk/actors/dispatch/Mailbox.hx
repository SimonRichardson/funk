package funk.actors.dispatch;

import funk.actors.ActorRefProvider.DeadLetters;
import funk.Funk;
import funk.actors.dispatch.EnvelopeMessage;
import funk.actors.dispatch.SystemMessage;
import funk.actors.dispatch.MessageQueue;
import funk.actors.Scheduler;
import funk.reactives.Process;
import funk.types.Any.AnyTypes;
import funk.types.AnyRef;

using funk.collections.immutable.List;
using funk.types.Option;
using funk.types.Tuple2;

@:keep
class Mailbox implements MessageQueue implements SystemMessageQueue implements Runnable {

    inline private static var Open : Int = 0;

    inline private static var Suspended : Int = 1;

    inline private static var Closed : Int = 2;

    inline private static var Scheduled : Int = 4;

    private var _actor : ActorCell;

    private var _dispatcher : Dispatcher;

    private var _messageQueue : MessageQueue;

    private var _systemMessageQueue : SystemMessageQueue;

    private var _status : Int;

    public function new(actor : ActorCell, messageQueue : MessageQueue) {
        _actor = actor;
        _dispatcher = _actor.dispatcher();
        _messageQueue = messageQueue;

        _systemMessageQueue = new DefaultSystemMessageQueue();

        _status = Open;
    }

    public function enqueue(receiver : ActorRef, envelope : EnvelopeMessage) : Void {
        _messageQueue.enqueue(receiver, envelope);
    }

    public function dequeue() : Option<EnvelopeMessage> return _messageQueue.dequeue();

    public function numberOfMessages() : Int return _messageQueue.numberOfMessages();

    public function hasMessages() : Bool return _messageQueue.hasMessages();

    public function systemEnqueue(receiver : ActorRef, message : SystemMessage) : Void {
        _systemMessageQueue.systemEnqueue(receiver, message);
    }

    public function systemDequeue() : Option<SystemMessage> return _systemMessageQueue.systemDequeue();

    public function numberOfSystemMessages() : Int return _systemMessageQueue.numberOfSystemMessages();

    public function hasSystemMessages() : Bool return _systemMessageQueue.hasSystemMessages();

    public function run() : Void {
        function finally() {
            setAsIdle();
            _dispatcher.registerForExecution(this, false, false);
        }

        try {
            if (!isClosed()) {
                processAllSystemMessages();

                var diff = Std.int(Process.stamp() + _dispatcher.throughputDeadlineTime());
                processMailbox(Std.int(Math.max(_dispatcher.throughput(), 1)), diff);
            }
        } catch(e : Dynamic) {
            finally();

            throw e;
        }

        finally();
    }

    public function name() : String return _dispatcher.name();

    public function becomeOpen() : Bool {
        return switch(_status) {
            case _ if((_status & Closed) == Closed):
                _status = Closed;
                false;
            case _:
                _status = Open | _status & Scheduled;
                true;
        }
    }

    public function becomeSuspended() : Bool {
        return switch(_status) {
            case _ if((_status & Closed) == Closed):
                _status = Closed;
                false;
            case _:
                _status = Suspended | _status & Scheduled;
                true;
        }
    }

    public function becomeClosed() : Bool {
        return switch(_status) {
            case _ if((_status & Closed) == Closed):
                _status = Closed;
                false;
            case _:
                _status = Closed;
                true;
        }
    }

    public function setAsScheduled() : Bool {
        return switch(_status) {
            case _ if((_status & Open) == Open):
                _status = _status | Scheduled;
                true;
            case _: false;
        }
    }

    public function setAsIdle() : Bool {
        _status = _status & ~Scheduled;
        return (_status & Scheduled) != Scheduled;
    }

    public function shouldProcessMessage() : Bool return (_status & Open) == Open;

    public function isSuspended() : Bool return (_status & Suspended) == Suspended;

    public function isClosed() : Bool return _status == Closed;

    public function isScheduled() : Bool return (_status & Scheduled) != 0;

    public function canBeScheduledForExecution(hasMessageHint : Bool, hasSystemMessageHint : Bool) : Bool {
        return switch(_status) {
            case _ if((_status & Open) == Open): hasMessageHint || hasSystemMessageHint || hasSystemMessages() || hasMessages();
            case _ if((_status & Scheduled) == Scheduled): true;
            case _: hasSystemMessageHint ||  hasSystemMessages();
        }
    }

    private function processAllSystemMessages() {
        function dispatch(msg : AnyRef) {
            _actor.system().eventStream().dispatch('Error while sending $msg to deadLetters');
        }

        while(!isClosed() && hasSystemMessages()) {
            switch(systemDequeue()) {
                case Some(msg): _actor.systemInvoke(msg);
                case _: dispatch('Invalid system message');
            }
        }

        while(hasSystemMessages()) {
            switch (systemDequeue()) {
                case Some(msg):
                    try {
                        var letters = _actor.system().deadLetters();
                        letters.send(msg, letters);
                    } catch(e : Dynamic) {
                        dispatch(msg);
                    }
                case _: dispatch('Invalid system message');
            }
        }
    }

    private function processMailbox(?left : Int = 1, ?deadlineNs : Int = 0) : Void {
        if (shouldProcessMessage()) {
            switch(dequeue()) {
                case Some(msg):
                    _actor.invoke(msg);

                    processAllSystemMessages();

                    if (left > 1 &&
                        (   (_dispatcher.isThroughputDeadlineTimeDefined() == false) ||
                            (Process.stamp() - deadlineNs < 0))
                        ){
                        processMailbox(left - 1, deadlineNs);
                    }
                case _:
            }
        }
    }
}

private class DefaultSystemMessageQueue implements SystemMessageQueue {

    private var _systemMessages : List<Tuple2<ActorRef, SystemMessage>>;

    public function new() {
        _systemMessages = Nil;
    }

    public function systemEnqueue(receiver : ActorRef, message : SystemMessage) : Void {
        _systemMessages = _systemMessages.append(tuple2(receiver, message));
    }

    public function systemDequeue() : Option<SystemMessage> {
        var head = _systemMessages.headOption();
        var msg = switch (head) {
            case Some(tuple): Some(tuple._2());
            case _: None;
        }
        _systemMessages = _systemMessages.tail();
        return msg;
    }

    public function numberOfSystemMessages() : Int return _systemMessages.size();

    public function hasSystemMessages() : Bool return _systemMessages.nonEmpty();
}
