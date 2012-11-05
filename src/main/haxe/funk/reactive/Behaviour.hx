package funk.reactive;

import funk.reactive.Propagation;
import funk.tuple.Tuple2;

class Behaviour<T> {

	public var stream(get_stream, never) : Stream<T>;
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

	public function lift<E>(func : T -> E) : Behaviour<E> {
		return _stream.map(func).startsWith(func(_value));
	}

	public function map<E>(behaviour : Behaviour<T -> E>) : Behaviour<E> {
		return _stream.map(function(x) {
			return behaviour.value(x);
		}).startsWith(behaviour.value(value));
	}

	public function zipWith<E1, E2>(behaviour : Behaviour<E1>, func : T -> E1 -> E2) : Behaviour<E2> {
		return Streams.create(function(pulse : Pulse<E1>) : Propagation<E2> {
			return Propagate(pulse.withValue(func(value, behaviour.value)));
		}, [this, behaviour]).startsWith(func(value, behaviour.value));
	}

	public function zip<E>(behaviour : Behaviour<E>) : Behaviour<ITuple2<T, E>> {
		return zipWith(behaviour, Tuple2Impl.create);
	}

	public function emit(value : T) : Void {
		_stream.emit(value);
	}

	public function values() : StreamValues<T> {
		return _stream.values();
	}

	private function get_stream() : Stream<T> {
		return _stream;
	}

	private function get_value() : T {
		return _value;
	}
}
