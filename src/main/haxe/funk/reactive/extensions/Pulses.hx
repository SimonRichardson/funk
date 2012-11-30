package funk.reactive.extensions;

import funk.reactive.Pulse;
import funk.types.Function1;

class Pulses {

	public static function time<T>(pulse : Pulse<T>) : Float {
		return switch (pulse) {
			case Pulse(time, _): time;
		}
	}

	public static function value<T>(pulse : Pulse<T>) : T {
		return switch (pulse) {
			case Pulse(_, value): value;
		}
	}

	public static function map<T, E>(pulse : Pulse<T>, func : Function1<T, E>) : Pulse<T> {
		return withValue(pulse, func(value(pulse)));
	}

	public static function withValue<T, E>(pulse : Pulse<T>, value : E) : Pulse<T> {
		return Pulse(time(pulse), func);
	}
}
