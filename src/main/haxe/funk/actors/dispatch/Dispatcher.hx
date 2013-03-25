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

    function registerForExecution(mailbox : Mailbox, hasMessageHint: Bool, hasSystemMessageHint: Bool) : Void;

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
        registerForExecution(mbox, true, false);
    }

    public function systemDispatch(receiver : ActorCell, invocation : SystemMessage) : Void {
        var mbox = receiver.mailbox();
        mbox.systemEnqueue(receiver.self(), invocation);
        registerForExecution(mbox, false, true);
    }

    public function name() : String return _name;

    public function registerForExecution(mailbox : Mailbox, hasMessageHint: Bool, hasSystemMessageHint: Bool) : Void {
        if (mailbox.canBeScheduledForExecution(hasMessageHint, hasSystemMessageHint)) {
            if(mailbox.setAsScheduled()) {
                try {
                    mailbox.run();
                } catch (e : Dynamic) {
                    mailbox.setAsIdle();
                }
            }
        }
    }

    public function throughput() : Int return 0;

    public function throughputDeadlineTime() : Int return 0;

    public function isThroughputDeadlineTimeDefined() : Bool return throughputDeadlineTime() > 0;
}
