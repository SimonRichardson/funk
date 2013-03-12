package funk.actors.dispatch;

class Dispatcher extends MessageDispatcher {

	private var _executorService : ExecutorService;

	public function new() {
		_executorService = new ExecutorService();
	}

	override public function createMailbox(actor : ActorCell) : Mailbox {
		return new Mailbox(actor);
	}

	public function dispatch(receiver : ActorCell, invocation : Envelope) {
		var mbox = receiver.mailbox();
		mbox.enqueue(receiver.self(), invocation);
		registerForExecution(mbox);
	}

	public function systemDispatch(receiver : ActorCell, invocation : SystemMessage) {
		var mbox = receiver.mailbox();
		mbox.systemEnqueue(receiver.self(), invocation);
		registerForExecution(mbox);
	}

	private function registerForExecution(mailbox : Mailbox) : Bool {
		return if (mailbox.setAsScheduled()) {
			try {
				_executorService.get().execute(mailbox);
				true;
			} catch (e : Dynamic) {
				false;
			}
		} else false;
	}
}