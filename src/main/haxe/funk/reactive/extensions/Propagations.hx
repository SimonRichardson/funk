package funk.reactive.extensions;

import funk.reactive.Propagation;
import funk.reactive.Pulse;
import funk.types.Function1;

class Propagations {

	public static function identity<T>() : Function1<Pulse<T>, Propagation<T>> {
		return function(pulse : Pulse<T>) : Propagation<T> {
			return Propagate(pulse);
		}
	}
}
