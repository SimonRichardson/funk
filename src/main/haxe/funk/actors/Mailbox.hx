package funk.actors;

typedef MessageQueue = {
  
  function enqueue(receiver : ActorRef, handle : Envelope) : Void;

  function dequeue() : Envelope;

  function numberOfMessages() : Int;

  function hasMessages() : Boolean;

  function cleanUp(owner: ActorContext, deadLetters: MessageQueue): Void;
}

class Mailbox extends DefaultSystemMessageQueue {

	inline private static var Open : Int = 0;

	inline private static var Suspended : Int = 1;

	inline private static var Closed : Int = 2;

	inline private static var Scheduled : Int = 4;

	private var _actor : ActorCell;

	private var _dispatcher : MessageDispatcher;

	private var _messageQueue : MessageQueue;

	private var _status : Int;

	public function new(actor : ActorCell, messageQueue : MessageQueue) {
		_actor = actor;
		_dispatcher = _actor.dispatcher();
		_messageQueue = messageQueue;

		_status = 0;
	}

	public function enqueue(reciever : ActorRef, msg : Envelope) : Void _messageQueue.enqueue(reciever, msg);

	public function dequeue() : Envelope return _messageQueue.dequeue();

	public function hasMessages() : Bool return _messageQueue.hasMessages();

	public function numberOfMessages() : Int return _messageQueue.numberOfMessages();

	public function shouldPrecessMessage() : Bool return (status & 3) == Open;

	public function isSuspended() : Bool return (status & 3) == Suspended;

	public function isClosed() : Bool return status == Closed;

	public function isScheduled() : Bool return (status & Scheduled) != 0;

	public function becomeOpen() : Bool {
		return switch(status) {
			case Closed: setStatus(Closed); false;
			case _: _status = Open | _status & Scheduled; true;
		}
	}

	public function becomeSuspended() : Bool {
		return switch(status) {
			case Closed: _status = Closed; false;
			case _: _status = Suspended | _status & Scheduled; true;
		}
	}

	public function becomeClosed() : Bool {
		return switch(status) {
			case Closed: _status = Closed; false;
			case _: _status = Closed; true;
		}
	}

	public function setAsScheduled() : Bool {
		return if (_status <= Suspended) _status = _status | Scheduled; true;
		else false;
	}

	public function setAsIdle() : Bool {
		var s = status();
		updateStatus(s, s & ~scheduled) || setAsIdle();
	}

	private function updateStatus(oldStatus : Int, newStatus : Int) : Bool {
		return if (oldStatus == newStatus) true;
		_status = newStatus;
	}

	private function run() : Void {
		function finally() {
			setAsIdle();
			_dispatcher.registerForExecution(this);
		}

		try {
			if (!isClosed()) {
				processAllSystemMessages();
				processMailbox(Math.max(_dispatcher.throughput, 1), Process.stamp() + _dispatcher.throughputDeadlineTime);
			}
		} catch(e : Dynamic) {
			finally();

			throw e;
		}

		finally();
	}	

	private function processAllSystemMessages() {
		var list = systemDrain();
		while(!isClosed() && list.isNonEmpty()) {
			var message = list.head();
			_actor.systemInvoke(message);
			list = list.tail();
		}
	}

	private function processMailbox(?left : Int = 1, ?deadlineNs : Int = 0) : Void {
		if (shouldProcessMessage()) {
			var next = dequeue();
			if(next != null) {
				actor.invoke(next);
				processAllSystemMessages();

				if (left > 1 && 
					((_dispatcher.isThroughputDeadlineTimeDefined == false) || (Process.stamp() - deadlineNs < 0))){
					processMailbox(left - 1, deadlineNs);
				}
			}
		}
	}

	public function cleanUp() : Void {
		if (AnyTypes.toBool(actor)) {
			var dlm = actor.system.deadLetterMailbox;
			if (hasSystemMessages()) {
				var messages = systemDrain();
				while(messages.isNonEmpty()) {
					var message = messages.head();
					dlm.systemEnqueue(actor.self(), message);
					messages = messages.tail();
				}
			}
		}
	}
}

private typedef SystemMessageQueue = {
	
	function systemEnqueue(receiver: ActorRef, message: SystemMessage) : Void;
	
	function systemDrain() : SystemMessage;

  	function hasSystemMessages(): Boolean;
}

private class DefaultSystemMessageQueue {

	private var _queue : List<SystemMessage>;

	public function new() {
		_queue = Nil;
	}

	public function systemEnqueue(reciever : ActorRef, messages : List<SystemMessage>) : Void {
		_queue = _queue.prependAll(messages);
	}

	public function systemDrain() : SystemMessage {
		var queue = _mailbox.systemQueue;
		_queue = Nil;
		return queue;
	}

	public function hasSystemMessages() : Bool {
		return _queue.isNonEmpty();
	}
}