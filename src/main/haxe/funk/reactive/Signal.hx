package funk.reactive;

import funk.reactive.Propagation;

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

	private function get_value() : T {
		return _value;
	}

}