package funk.reactive;

import funk.types.Function1;

class Behaviour<T> {

	private var _stream : Stream<T>;

	private var _pulse : Function1<Pulse<T>, Propagation<T>>;

	private var _value : T;

	public function new(stream: Stream<T>, value : T, pulse : Function1<Pulse<T>, Propagation<T>>) {
		_value = value;
		_pulse = pulse;

		_stream = Streams.create(function(pulse : Pulse<T>) : Propagation<T> {
			var prop = _pulse(pulse);
			switch(prop) {
				case Propagate(value):
					_value = value.value();
				case Negate:
			}
			return prop;
		}, [stream.steps()]);
	}

	public function stream() : Stream<T> {
		return _stream;
	}

	public function value() : T {
		return _value;
	}
}
