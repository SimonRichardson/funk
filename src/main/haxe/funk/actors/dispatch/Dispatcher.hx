package funk.actors.dispatch;

import funk.actors.ActorCell;
import funk.actors.dispatch.Envelope;
import funk.actors.dispatch.Mailbox;
import funk.actors.dispatch.MessageQueue;
import funk.actors.dispatch.SystemMessage;

using funk.types.Option;
using funk.collections.immutable.List;

interface Dispatcher {

    function createMailbox(actor : ActorCell) : Mailbox;

    function dispatch(actor : ActorCell, envelope : Envelope) : Void;

    function systemDispatch(receiver : ActorCell, invocation : SystemMessage) : Void;

    function name() : String;

    function throughput() : Int;

    function throughputDeadlineTime() : Int;

    function isThroughputDeadlineTimeDefined() : Bool;
}

class MessageDispatcher implements Dispatcher {

    private var _name : String;

    public function new(name : String) {
        _name = name;
    }

    public function createMailbox(actor : ActorCell) : Mailbox {
        return new Mailbox(actor, MailboxMessageQueue.create(actor.toOption()));
    }

    public function dispatch(receiver : ActorCell, invocation : Envelope) : Void {
        var mbox = receiver.mailbox();
        mbox.enqueue(receiver.self(), invocation);
        registerForExecution(mbox);
    }

    public function systemDispatch(receiver : ActorCell, invocation : SystemMessage) : Void {
        var mbox = receiver.mailbox();
        mbox.systemEnqueue(receiver.self(), invocation);
        registerForExecution(mbox);
    }

    public function name() : String return _name;

    private function registerForExecution(mailbox : Mailbox) : Void {
        // TODO (Simon) : Use a process for this.
        mailbox.run();
    }

    public function throughput() : Int return 0;

    public function throughputDeadlineTime() : Int return 0;

    public function isThroughputDeadlineTimeDefined() : Bool return throughputDeadlineTime() > 0;
}
