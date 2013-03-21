package funk.actors.dispatch;

import funk.actors.dispatch.Mailbox;

using funk.types.Option;
using funk.collections.immutable.List;

class Dispatcher extends MessageDispatcher {

    public function new() {
        super();
    }

    override public function createMailbox(actor : ActorCell) : Mailbox {
        return new Mailbox(actor, MailboxType.create(actor.context().toOption()));
    }
}
