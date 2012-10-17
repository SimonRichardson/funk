package funk.reactive;

class Stream<T> {

	private var _rank : Int;

	private var _propagator : Pulse<T> -> Propagation<T>;

	private var _listeners : Array<Stream<T>>;

	public function new(	propagator : Pulse<T> -> Propagation<T>,
							sources : Array<Stream<T>> = null
							) {
		_rank = Rank.next();
		_propagator = propagator;
		_listeners = [];

		if(sources != null && sources.length > 0) {
			for(source in sources) {
				source.attachListener(this);
			}
		}
	}

	public function attachListener(listener : Stream<T>) : Void {
		_listeners.push(listener);

		if(_rank > listener._rank) {
			var lowest = Rank.last() + 1;
			var listeners : Array<Stream<T>> = [listener];

            while(listeners.length > 0) {
                var item = listeners.shift();

                item._rank = Rank.next();

                var itemListeners = item._listeners;
                if(itemListeners.length > 0) {
                	listeners = listeners.concat(itemListeners);
            	}
            }
		}
	}

	public function forEach(func: T -> Void): Stream<T> {
        Streams.create(
        	function(pulse: Pulse<T>): Propagation<T> {
                func(pulse.value);

                return Negate;
            },
            [this]
        );

        return this;
    }

}


private class Rank {

	private static var _value : Int = 0;

    public static function last(): Int {
        return _value;
    }

    public static function next(): Int {
        return _value++;
    }
}
