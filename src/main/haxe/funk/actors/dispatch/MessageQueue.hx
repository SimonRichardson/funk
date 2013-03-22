package funk.actors.dispatch;

import funk.actors.ActorRef;
import funk.actors.dispatch.Envelope;
import funk.actors.dispatch.SystemEnvelope;

using funk.collections.immutable.List;
using funk.types.Option;

interface MessageQueue {

  function enqueue(receiver : ActorRef, handle : Envelope) : Void;

  function dequeue() : Envelope;

  function numberOfMessages() : Int;

  function hasMessages() : Bool;
}

interface SystemMessageQueue {

    function systemEnqueue(receiver : ActorRef, handle : SystemEnvelope) : Void;

    function systemDequeue() : SystemEnvelope;

    function numberOfSystemMessages() : Int;

    function hasSystemMessages() : Bool;
}

class MailboxMessageQueue {

    public static function create(actor : Option<ActorCell>) : MessageQueue {
        return switch(actor) {
            case Some(_): new UnboundedMessageQueue();
            case _: Funk.error(ActorError("Expected ActorCell but received none"));
        }
    }
}

private class UnboundedMessageQueue implements MessageQueue {

    private var _list : List<Envelope>;

    public function new() {
        _list = Nil;
    }

    public function enqueue(receiver : ActorRef, handle : Envelope) : Void _list = _list.append(handle);

    public function dequeue() : Envelope {
        var head = _list.head();
        _list = _list.tail();
        return head;
    }

    public function numberOfMessages() : Int return _list.size();

    public function hasMessages() : Bool return _list.nonEmpty();
}
