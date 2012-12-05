package funk.reactive;

import funk.types.Function1;
import funk.types.Option;
import funk.reactive.Propagation;
import funk.reactive.Pulse;
import funk.reactive.extensions.Pulses;
import funk.reactive.extensions.Streams;
import funk.collections.extensions.CollectionsUtil;

using funk.reactive.extensions.Pulses;
using funk.reactive.extensions.Streams;
using funk.collections.extensions.CollectionsUtil;

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
		}, Some([stream.steps()].toCollection()));
	}

	public function stream() : Stream<T> {
		return _stream;
	}

	public function value() : T {
		return _value;
	}
}
