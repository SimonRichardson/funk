package funk.actors.dispatch;

using funk.actors.dispatch.MessageDispatcher;
using funk.actors.Actor;
using funk.actors.ActorCell;
using funk.actors.ActorRef;
using funk.reactives.Process;
using funk.types.Any;
using funk.types.Option;
using funk.actors.dispatch.Envelope;
using funk.collections.immutable.List;

interface MessageQueue {

  function enqueue(receiver : ActorRef, handle : EnvelopeMessage) : Void;

  function dequeue() : EnvelopeMessage;

  function numberOfMessages() : Int;

  function hasMessages() : Bool;
}

class MailboxType {

    public static function create(owner : Option<ActorContext>) : MessageQueue {
        return null;
    }
}

class Mailbox {

}
