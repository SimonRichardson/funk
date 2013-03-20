package funk.actors.dispatch;

using funk.Funk;
using funk.collections.immutable.List;
using funk.actors.ActorRef;
using funk.actors.Scheduler;
using funk.actors.dispatch.Envelope;

enum SystemMessage {
    Create;
    Recreate(cause : Errors);
    Suspend;
    Resume;
    Stop;
    Link(subject : ActorRef);
    Unlink(subject : ActorRef);
    Terminated;
    Supervise(child : InternalActorRef);
    ChildCreated(child : InternalActorRef);
    ChildTerminated(child : InternalActorRef);
    Message(value : String);
}

enum UnhandledMessage {
    Unhandled(message : EnumValue, sender : ActorRef, self : ActorRef);
}

class MessageDispatcher {

    private var _id : String;

    private var _inhabitants : List<MessageDispatcher>;

    public function new() {
        _inhabitants = Nil;
    }

    public function createMailbox(actor : ActorCell) : Mailbox {
        return null;
    }

    public function systemDispatch(reciever : ActorCell, invocation : SystemMessage) : Void {
    }

    public function dispatch(reciever : ActorCell, invocation : EnvelopeMessage) : Void {
    }

    public function attach(actor : ActorCell) : Void {
        register(actor);
        registerForExecution(actor.mailbox());
    }

    public function detach(actor : ActorCell) : Void {
        unregister(actor);
    }

    public function suspend(actor : ActorCell) : Void {
        var mailbox = actor.mailbox();
        if (mailbox.dispatcher() == this) {
            mailbox.becomeSuspended();
        }
    }

    public function resume(actor : ActorCell) : Void {
        var mailbox = actor.mailbox();
        if (mailbox.dispatcher() == this && mailbox.becomeOpen()) {
            registerForExecution(mailbox);
        }
    }

    public function name() : String return _id;

    public function throughput() : Int return 0;

    public function throughputDeadlineTime() : Int return 0;

    public function isThroughputDeadlineTimeDefined() : Bool return throughputDeadlineTime() > 0;

    public function execute(actor : ActorCell) : Void {
        var mailbox = actor.mailbox();
        mailbox.run();
    }

    private function register(actor : ActorCell) {
        _inhabitants = _inhabitants.prepend(this);
    }

    private function unregister(actor : ActorCell) {
        _inhabitants = _inhabitants.filterNot(function(value) {
            return value == this;
        });

        var mailbox = actor.mailbox();
        mailbox.becomeClosed();
        mailbox.cleanUp();
    }

    @:allow(funk.actors.dispatch)
    private function registerForExecution(mailbox : Mailbox) : Bool return false;
}
