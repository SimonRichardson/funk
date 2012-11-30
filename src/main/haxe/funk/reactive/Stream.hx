package funk.reactive;

class Stream<T> {

	public var weakRef(get_weakRef, set_weakRef) : Bool;

	private var _rank : Int;

    private var _weakRef : Bool;

	private var _propagator : Function1<Pulse<T>, Propagation<T>>;

	private var _listeners : Array<Stream<T>>;

    private var _finishedListeners : ISignal0;

	public function new(	propagator : Function1<Pulse<T>, Propagation<T>>,
							sources : Array<Stream<T>> = null) {
		_rank = Rank.next();
		_propagator = propagator;
		_listeners = [];

        _weakRef = false;

        _finishedListeners = new Signal0();

		if(sources != null && sources.length > 0) {
			for(source in sources) {
				source.attachListener(this);
			}
		}
	}
}
