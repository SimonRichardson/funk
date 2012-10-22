package funk.reactive;

import funk.reactive.Propagation;
import funk.tuple.Tuple2;

class Signal<T> {

	public var value(get_value, never) : T;

	private var _stream : Stream<T>;
	private var _pulse : Pulse<T> -> Propagation<T>;
	private var _value : T;

	public function new(stream: Stream<T>, value : T, pulse : Pulse<T> -> Propagation<T>) {
		_value = value;
		_pulse = pulse;

		_stream = Streams.create(function(pulse : Pulse<T>) : Propagation<T> {
			var prop = _pulse(pulse);
			switch(prop) {
				case Propagate(value):
					_value = value.value;
				case Negate:
			}
			return prop;
		}, [stream.steps()]);
	}

	public function map<E>(signal : Signal<T -> E>) : Signal<E> {
		return _stream.map(function(x) {
			return signal.value(x);
		}).startsWith(signal.value(value));
	}

	public function zipWith<E1, E2>(signal : Signal<E1>, func : T -> E1 -> E2) : Signal<E2> {
		return Streams.create(function(pulse : Pulse<E1>) : Propagation<E2> {
			return Propagate(pulse.withValue(func(value, signal.value)));
		}, [this, signal]).startsWith(func(value, signal.value));
	}

	public function zip<E>(signal : Signal<E>) : Signal<ITuple2<T, E>> {
		return zipWith(signal, Tuple2Impl.create);
	}

	public function emit(value : T) : Void {
		_stream.emit(value);
	}

	private function get_value() : T {
		return _value;
	}

	public function toArray() : Array<T> {
		return _stream.toArray();
	}
}
