package funk.actors.dispatch;

enum Envelope<T> {
	Envelope(message : T, sender : ActorRef);
}

enum SystemMessage {
    Create;
    Recreate(cause : Errors);
    Suspend;
    Resume;
    Stop;
    Link(subject : ActorRef);
    Unlink(subject : ActorRef);
    Terminate;
    Supervise(child : ActorRef);
    ChildTerminated(child : ActorRef);
}

enum UnhandledMessage<T> {
    UnhandledMessage(message : T, sender : ActorRef, self : ActorRef);
}

class MessageDispatcher {

	private var _id : String;

	public function new() {
	}

	public function createMailbox(actor : ActorCell) : Mailbox {
	}

	public function systemDispatch(reciever : ActorCell, invocation : SystemMessage) : Void {
	}

	public function dispatch(reciever : ActorCell, invocation : Envelope) : Void {
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
		if (mailbox.dispatcher == this) {
			mailbox.becomeSuspended();
		}
	}

	public function resume(actor : ActorCell) : Void {
		var mailbox = actor.mailbox();
		if (mailbox.dispatcher == this && mailbox.becomeOpen()) {
			registerForExecution(mailbox);
		}
	}

	public function name() : String {
		return _id;
	}

	public function throughput() : Int {
		return 0;
	}

	public function throughputDeadlineTime() : Int {
		return 0;
	}

	public function isThroughputDeadlineTimeDefined() : Bool {
		return throughputDeadlineTime() > 0;
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

	private function registerForExecution(mailbox : Mailbox) : Void {

	}
}
