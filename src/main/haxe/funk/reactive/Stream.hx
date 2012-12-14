package funk.reactive;

import funk.reactive.Pulse;
import funk.reactive.Propagation;
import funk.reactive.Stream;
import funk.signals.Signal0;
import funk.types.Function0;
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

    public function attachListener(listener : Stream<T>) : Void {
        _listeners.push(listener);

        if(_rank > listener._rank) {
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

    public function detachListener(listener : Stream<T>, ?weakReference : Bool = false): Bool {
        var removed = false;

        var index = _listeners.length;
        while(--index > -1) {
            if(_listeners[index] == listener) {
                _listeners.splice(index, 1);
                removed = true;
                break;
            }
        }

        if(weakReference && _listeners.length == 0) {
            weakRef = true;
        }

        return removed;
    }

    public function emit(value : T) : Stream<T> {
        var time = Process.stamp();
        var pulse = Pulse(time, value);

        // This will propagate through all listeners
        var queue = new PriorityQueue<{stream: Stream<T>, pulse: Pulse<T>}>();
        queue.insert(_rank, {
            stream: this,
            pulse: pulse
        });

        while (queue.size() > 0) {
            var keyValue = queue.pop().value;

            var stream = keyValue.stream;
            var pulse  = keyValue.pulse;

            switch (stream._propagator(pulse)) {
                case Propagate(p): {
                    var weak = true;

                    for (listener in stream._listeners) {
                        weak = weak && listener.weakRef;

                        var index = listener._rank;
                        queue.insert(index, {stream: listener, pulse: p});
                    }

                    if(stream._listeners.length > 0 && weak) {
                        stream.weakRef = true;
                    }
                }

                case Negate:
            }
        }

        return this;
    }

    public function finish() : Void {
        weakRef = true;
        // TODO : We should prevent it from coming back.
    }

    public function whenFinishedDo(func : Function0<Void>) : Void {
        if(_weakRef) {
            func();
        } else {
            _finishedListeners.add(func);
        }
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

private typedef KeyValue<T> = {
    key: Int,
    value: T
};

private class PriorityQueue<T> {

    private var _values : Array<KeyValue<T>>;

    public function new() {
        _values = [];
    }

    public function insert(index : Int, value : T) : Void {
        var keyValue = {
            key: index,
            value: value
        };

        var added = false;

        for (i in 0..._values.length) {
            var val = _values[i];

            if (index > val.key) {
                added = true;

                _values.insert(i, keyValue);

                break;
            }
        }

        if (!added) {
            _values.push(keyValue);
        }
    }

    public function pop() : KeyValue<T> {
        return _values.pop();
    }

    public function size(): Int {
        return _values.length;
    }
}
