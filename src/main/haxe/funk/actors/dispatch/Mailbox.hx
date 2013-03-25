package funk.actors.dispatch;

import funk.Funk;
import funk.actors.dispatch.Envelope;
import funk.actors.dispatch.SystemMessage;
import funk.actors.dispatch.MessageQueue;
import funk.actors.Scheduler;
import funk.reactives.Process;
import funk.types.Any.AnyTypes;

using funk.collections.immutable.List;
using funk.types.Option;
using funk.types.Tuple2;

@:keep
class Mailbox implements MessageQueue implements SystemMessageQueue implements Runnable {

    private var _actor : ActorCell;

    private var _dispatcher : Dispatcher;

    private var _messageQueue : MessageQueue;

    private var _systemMessageQueue : SystemMessageQueue;

    public function new(actor : ActorCell, messageQueue : MessageQueue) {
        _actor = actor;
        _dispatcher = _actor.dispatcher();
        _messageQueue = messageQueue;

        _systemMessageQueue = new DefaultSystemMessageQueue();
    }

    public function enqueue(receiver : ActorRef, envelope : Envelope) : Void _messageQueue.enqueue(receiver, envelope);

    public function dequeue() : Option<Envelope> return _messageQueue.dequeue();

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

        }

        try {
            processAllSystemMessages();

            var diff = Std.int(Process.stamp() + _dispatcher.throughputDeadlineTime());
            processMailbox(Std.int(Math.max(_dispatcher.throughput(), 1)), diff);
        } catch(e : Dynamic) {
            finally();

            throw e;
        }

        finally();
    }

    public function name() : String return _dispatcher.name();

    private function processAllSystemMessages() {
        while(hasSystemMessages()) {
            switch(systemDequeue()) {
                case Some(msg): _actor.systemInvoke(msg);
                case _:
            }
        }
    }

    private function processMailbox(?left : Int = 1, ?deadlineNs : Int = 0) : Void {
        switch(dequeue()) {
            case Some(msg):
                _actor.invoke(msg);

                processAllSystemMessages();

                if (left > 1 &&
                    ((_dispatcher.isThroughputDeadlineTimeDefined() == false) || (Process.stamp() - deadlineNs < 0))){
                    processMailbox(left - 1, deadlineNs);
                }
            case _:
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
