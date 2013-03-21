package funk.actors.dispatch;

import funk.Funk;
import funk.actors.dispatch.Envelope;
import funk.actors.dispatch.SystemEnvelope;
import funk.actors.Scheduler;

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

class MailboxType {

    public static function create(actor : Option<ActorCell>) : Mailbox {
        return switch(actor) {
            case Some(_): new UnboundMailbox();
            case _: Funk.error(ActorError("Expected ActorCell but received none"));
        }
    }
}

class Mailbox implements MessageQueue implements SystemMessageQueue implements Runmable {

    public function new() {

    }

    public function enqueue(receiver : ActorRef, handle : Envelope) : Void {

    }

    public function dequeue() : Envelope {

    }

    public function numberOfMessages() : Int {

    }

    public function hasMessages() : Bool {

    }

    public function systemEnqueue(receiver : ActorRef, handle : SystemEnvelope) : Void {

    }

    public function systemDequeue() : SystemEnvelope {

    }

    public function numberOfSystemMessages() : Int {

    }

    public function hasSystemMessages() : Bool {

    }

    public function run() : Void {

    }
}

private class UnboundMailbox extends Mailbox {

    public function new() {
        super();
    }
}
