package funk.actors.dispatch;

using funk.actors.dispatch.MessageDispatcher;
using funk.actors.ActorCell;
using funk.reactives.Process;
using funk.types.Any;
using funk.types.Option;
using funk.actors.dispatch.Envelope;
using funk.collections.immutable.List;

typedef MessageQueue = {

  function enqueue(receiver : ActorRef, handle : Envelope) : Void;

  function dequeue() : Envelope;

  function numberOfMessages() : Int;

  function hasMessages() : Bool;

  function cleanUp(owner: ActorContext, deadLetters: MessageQueue): Void;
}

class MailboxType {

    public static function create(owner : Option<ActorContext>) : MessageQueue {
        // TODO (Simon) : Fill this in with different items, depending on the context.
        return new UnboundedMailbox();
    }
}

@:allow(funk.actors.dispatch.Dispatcher)
class Mailbox extends DefaultSystemMessageQueue {

    inline private static var Open : Int = 0;

    inline private static var Suspended : Int = 1;

    inline private static var Closed : Int = 2;

    inline private static var Scheduled : Int = 4;

    private var _actor : ActorCell;

    private var _dispatcher : MessageDispatcher;

    private var _messageQueue : MessageQueue;

    private var _status : Int;

    public function new(actor : ActorCell, messageQueue : MessageQueue) {
        super();

        _actor = actor;
        _dispatcher = _actor.dispatcher();
        _messageQueue = messageQueue;

        _status = 0;
    }

    public function enqueue(reciever : ActorRef, msg : Envelope) : Void _messageQueue.enqueue(reciever, msg);

    public function dequeue() : Envelope return _messageQueue.dequeue();

    public function hasMessages() : Bool return _messageQueue.hasMessages();

    public function numberOfMessages() : Int return _messageQueue.numberOfMessages();

    public function shouldProcessMessage() : Bool return (_status & 3) == Open;

    public function isSuspended() : Bool return (_status & 3) == Suspended;

    public function isClosed() : Bool return _status == Closed;

    public function isScheduled() : Bool return (_status & Scheduled) != 0;

    public function becomeOpen() : Bool {
        return switch(_status) {
            case Closed: setStatus(Closed); false;
            case _: _status = Open | _status & Scheduled; true;
        }
    }

    public function becomeSuspended() : Bool {
        return switch(_status) {
            case Closed: _status = Closed; false;
            case _: _status = Suspended | _status & Scheduled; true;
        }
    }

    public function becomeClosed() : Bool {
        return switch(_status) {
            case Closed: _status = Closed; false;
            case _: _status = Closed; true;
        }
    }

    public function setAsScheduled() : Bool {
        return if (_status <= Suspended) { _status = _status | Scheduled; true; }
        else { false; }
    }

    public function setAsIdle() : Bool {
        var s = _status;
        return updateStatus(s, s & ~scheduled) || setAsIdle();
    }

    private function updateStatus(oldStatus : Int, newStatus : Int) : Bool {
        return if (oldStatus == newStatus) true;
        else _status = newStatus; true;
    }

    private function run() : Void {
        function finally() {
            setAsIdle();
            _dispatcher.registerForExecution(this);
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

    private function processAllSystemMessages() {
        var list = systemDrain();
        while(!isClosed() && list.nonEmpty()) {
            var message = list.head();
            _actor.systemInvoke(message);
            list = list.tail();
        }
    }

    private function processMailbox(?left : Int = 1, ?deadlineNs : Int = 0) : Void {
        if (shouldProcessMessage()) {
            var next = dequeue();
            if(next != null) {
                _actor.invoke(next);
                processAllSystemMessages();

                if (left > 1 &&
                    ((_dispatcher.isThroughputDeadlineTimeDefined() == false) || (Process.stamp() - deadlineNs < 0))){
                    processMailbox(left - 1, deadlineNs);
                }
            }
        }
    }

    public function cleanUp() : Void {
        if (AnyTypes.toBool(_actor)) {
            var dlm = _actor.system().deadLetterMailbox();
            if (hasSystemMessages()) {
                var messages = systemDrain();
                dlm.systemEnqueue(_actor.self(), message);
            }
        }
    }
}

class DeadLetterQueue {

    private var _deadLetters : ActorRef;

    public function new(deadLetters : ActorRef) {
        _deadLetters = deadLetters;
    }

    public function enqueue(receiver : ActorRef, envelope : Envelope) : Void {
        var sender = envelope.sender();
        _deadLetters.tell(DeadLetter(envelope.message(), sender, receiver), sender);
    }

      public function dequeue() : Envelope return null;

      public function numberOfMessages() : Int return 0;

      public function hasMessages() : Bool return false;

      public function cleanUp(owner: ActorContext, deadLetters: MessageQueue): Void {
      }
}

class DeadLetterMailbox extends Mailbox {

    private var _deadLetters : ActorRef;

    public function new(deadLetters : ActorRef, queue : DeadLetterQueue) {
        super(null, queue);

        _deadLetters = deadLetters;

        becomeClosed();
    }

    override public function systemEnqueue(reciever : ActorRef, handle : List<SystemMessage>) : Void {
        _deadLetters.tell(DeadLetter(handle, reciever, reciever), _deadLetters.self());
    }

    override public function systemDrain() : List<SystemMessage> return Nil;

    override public function hasSystemMessages() : Bool return false;
}

private typedef SystemMessageQueue = {

    function systemEnqueue(receiver: ActorRef, message: List<SystemMessage>) : Void;

    function systemDrain() : List<SystemMessage>;

      function hasSystemMessages(): Bool;
}

private class DefaultSystemMessageQueue {

    private var _queue : List<SystemMessage>;

    public function new() {
        _queue = Nil;
    }

    public function systemEnqueue(reciever : ActorRef, messages : List<SystemMessage>) : Void {
        _queue = _queue.prependAll(messages);
    }

    public function systemDrain() : List<SystemMessage> {
        var queue = _queue;
        _queue = Nil;
        return queue;
    }

    public function hasSystemMessages() : Bool {
        return _queue.nonEmpty();
    }
}

private class UnboundedMailbox {

    private var _list : List<Envelope>;

    public function new() {
        _list = Nil;
    }

    public function enqueue(receiver : ActorRef, handle : Envelope) : Void { _list = _list.prepend(handle); }

      public function dequeue() : Envelope return _list.head();

      public function numberOfMessages() : Int return _list.size();

      public function hasMessages() : Bool return _list.nonEmpty();

      public function cleanUp(owner: ActorContext, deadLetters: MessageQueue): Void {
          if (hasMessages()) {
              var list = _list;
              while(list.nonEmpty()) {
                  var head = list.head();
                  deadLetters.enqueue(owner.self(), head);
                  list = list.tail();
              }
          }
      }

}
