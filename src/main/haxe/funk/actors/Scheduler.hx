package funk.actors;

typedef Cancellable = {

	function cancel() : Void;

	function isCancelled() : Bool;
}

typedef Scheduler = {

    function schedule<T>(reciever : ActorRef, message : T) : Cancellable;

    function scheduleOnce<T>(reciever : ActorRef, message : T) : Cancellable;
}

class DefaultScheduler {

	private var _dispatcher : Function1<Void, MessageDispatcher>;

	public function new(dispatcher : Function1<Void, MessageDispatcher>) {
		_dispatcher = dispatcher;
	}

	public function schedule<T>(reciever : ActorRef, message : T) : Cancellable {
		var task = Process.start(function() {
			_dispatcher().execute(this);
		}, 1);

		var isCancelled = false;

		return {
			cancel: function() return task.foreach(function(value) { value.stop(); isCancelled = true; });
			isCancelled: function() return isCancelled;
		};
	}

    public function scheduleOnce<T>(reciever : ActorRef, message : T) : Cancellable {
    	var task = Process.start(function() {
			_dispatcher().execute(this);
		}, 1);

		var isCancelled = false;

		if (task.isDefined()) {
			task.stop();
			isCancelled = true;
		}

		return {
			cancel: function() return task.foreach(function(value) { value.stop(); isCancelled = true; });
			isCancelled: function() return isCancelled;
		};
    }
}