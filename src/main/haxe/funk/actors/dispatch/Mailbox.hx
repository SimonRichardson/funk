package funk.actors.dispatch;

import funk.Funk;
import funk.actors.dispatch.Envelope;
import funk.actors.dispatch.SystemEnvelope;
import funk.actors.dispatch.MessageQueue;
import funk.actors.Scheduler;
import funk.reactives.Process;
import funk.types.Any.AnyTypes;

using funk.types.Option;

@:keep
class Mailbox implements MessageQueue implements SystemMessageQueue implements Runnable {

    private var _actor : ActorCell;

    private var _dispatcher : Dispatcher;

    private var _messageQueue : MessageQueue;

    public function new(actor : ActorCell, messageQueue : MessageQueue) {
        _actor = actor;
        _dispatcher = _actor.dispatcher();
        _messageQueue = messageQueue;
    }

    public function enqueue(receiver : ActorRef, envelope : Envelope) : Void _messageQueue.enqueue(receiver, envelope);

    public function dequeue() : Envelope return _messageQueue.dequeue();

    public function numberOfMessages() : Int return _messageQueue.numberOfMessages();

    public function hasMessages() : Bool return _messageQueue.hasMessages();

    public function systemEnqueue(receiver : ActorRef, handle : SystemEnvelope) : Void {

    }

    public function systemDequeue() : SystemEnvelope {
        return null;
    }

    public function numberOfSystemMessages() : Int {
        return -1;
    }

    public function hasSystemMessages() : Bool {
        return false;
    }

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

    }

    private function processMailbox(?left : Int = 1, ?deadlineNs : Int = 0) : Void {
        var next = dequeue();
        if (AnyTypes.toBool(next)) {
            _actor.invoke(next);

            processAllSystemMessages();

            if (left > 1 &&
                ((_dispatcher.isThroughputDeadlineTimeDefined() == false) || (Process.stamp() - deadlineNs < 0))){
                processMailbox(left - 1, deadlineNs);
            }
        }
    }
}
