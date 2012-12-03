package funk.reactive;

import funk.reactive.Pulse;
import funk.reactive.Propagation;
import funk.reactive.Stream;
import funk.signal.Signal0;
import funk.types.Function1;

class Stream<T> {

	public var weakRef(get_weakRef, set_weakRef) : Bool;

	private var _rank : Int;

    private var _weakRef : Bool;

	private var _propagator : Function1<Pulse<T>, Propagation<T>>;

	private var _listeners : Array<Stream<T>>;

    private var _finishedListeners : ISignal0;

	public function new(propagator : Function1<Pulse<T>, Propagation<T>>) {
		_rank = Rank.next();
		_propagator = propagator;
		_listeners = [];

        _weakRef = false;

        _finishedListeners = new Signal0();
	}

    public function emit(value : T) : Stream<T> {
        var time = Process.stamp();
        var pulse = Pulse(time, value);

        return this;
    }

	private function attachListener(listener : Stream<T>) : Void {
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

    private function detachListener(listener : Stream<T>, ?weakReference : Bool = false): Bool {
        var index = _listeners.length;
        while(--index > -1) {
            if(_listeners[index] == listener) {
                _listeners.splice(index, 1);
                return true;
            }
        }

        if(weakReference && _listeners.length == 0) {
            weakRef = true;
        }

        return false;
    }

	public function get_weakRef() : Bool {
        return _weakRef;
    }

    public function set_weakRef(value : Bool) : Bool {
        if(_weakRef != value) {
            _weakRef = value;

            if(_weakRef) {
                _finishedListeners.dispatch();
                _finishedListeners.removeAll();
            }
        }

        return value;
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
