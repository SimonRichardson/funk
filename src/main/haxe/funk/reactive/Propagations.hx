package funk.reactive;

import funk.Funk;
import funk.reactive.Propagation;

class Propagations {

	public static function identity<T>() : Function1<Pulse<T>, Propagation<T>> {
		return function(pulse : Pulse<T>) : Propagation<T> {
			return Propagate(pulse);
		}
	}
}
