package funk.actors.dispatch;

import funk.Funk;
import funk.actors.ActorRefProvider.DeadLetters;
import funk.actors.dispatch.EnvelopeMessage;
import funk.actors.dispatch.SystemMessage;
import funk.actors.dispatch.MessageQueue;
import funk.actors.events.EventStream;
import funk.actors.events.LoggingBus;
import funk.actors.Scheduler;
import funk.reactives.Process;
import funk.types.Any.AnyTypes;
import funk.types.AnyRef;
import funk.io.logging.LogLevel;
import funk.io.logging.LogValue;

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

    private var _eventStream : EventStream;

    public function new(actor : ActorCell, messageQueue : MessageQueue) {
        _actor = actor;
        _messageQueue = messageQueue;

        _dispatcher = _actor.dispatcher();
        _eventStream = _actor.system().eventStream();
        
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

            _eventStream.publish(Data(Error, ErrorMessage(  e, 
                                                            _actor.self().path().toString(), 
                                                            Type.getClass(_actor),
                                                            "exception during processing or mailbox"
                                                            )));

            throw e;
        }

        finally();
    }

    public function actor() : ActorCell return _actor;

    public function dispatcher() : Dispatcher return _dispatcher;

    public function name() : String return _dispatcher.name();

    public function status() : Int return _status;

    public function resume() : Bool {
        return switch(_status) {
            case _ if((_status & Closed) == Closed):
                _status = Closed;
                false;
            case _:
                _status &= ~Suspended;
                true;
        }
    }

    public function suspend() : Bool {
        return switch(_status) {
            case _ if((_status & Closed) == Closed):
                _status = Closed;
                false;
            case _:
                _status |= Suspended;
                true;
        }
    }

    public function becomeOpen() : Bool {
        return switch(_status) {
            case _ if((_status & Closed) == Closed):
                _status = Closed;
                false;
            case _:
                _status |= Open;
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
                _status |= Scheduled;
                true;
            case _: false;
        }
    }

    public function setAsIdle() : Bool {
        _status &= ~Scheduled;
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
            _actor.system().eventStream().publish(Data(Debug, 'Error while sending $msg to deadLetters'));
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

    public function messageQueue() : MessageQueue return _messageQueue;

    public function cleanUp(owner : ActorRef, deadLetters : MessageQueue) : Void {
        // We could dispose of things here.
        dispose();
    }

    public function dispose() : Void {
        if (_actor.toBool()) {
            var self = _actor.self();
            var sys = _actor.system();
            var dlm = sys.deadLetterMailbox();
            while(hasSystemMessages()) {
                switch(systemDequeue()) {
                    case Some(msg): dlm.systemEnqueue(self, msg);
                    case _:
                }
            }

            if(_messageQueue.toBool()) _messageQueue.cleanUp(self, sys.deadLetterQueue());
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
