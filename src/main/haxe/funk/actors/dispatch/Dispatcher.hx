package funk.actors.dispatch;

using funk.actors.dispatch.MessageDispatcher;

@:allow(funk.actors.dispatch)
class Dispatcher extends MessageDispatcher {

    public function new() {
    }

    override public function createMailbox(actor : ActorCell) : Mailbox {
        return new Mailbox(actor, MailboxType.create(actor.context()));
    }

    override public function dispatch(receiver : ActorCell, invocation : Envelope) {
        var mbox = receiver.mailbox();
        mbox.enqueue(receiver.self(), invocation);
        registerForExecution(mbox);
    }

    override public function systemDispatch(receiver : ActorCell, invocation : SystemMessage) {
        var mbox = receiver.mailbox();
        mbox.systemEnqueue(receiver.self(), invocation);
        registerForExecution(mbox);
    }

    override private function registerForExecution(mailbox : Mailbox) : Bool {
        return if (mailbox.setAsScheduled()) {
            try {
                // TODO (Simon) : We could put this in a Thread.
                mailbox.run();
                true;
            } catch (e : Dynamic) {
                mailbox.setAsIdle();
                false;
            }
        } else false;
    }
}
