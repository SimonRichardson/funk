package funk.actors;

class Dispatcher {

	private var _executorService : ExecutorService;

	public function new() {
		_executorService = new ExecutorService();
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