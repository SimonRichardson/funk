package funk.reactive;

import funk.reactive.Propagation;

class Propagations {

	public static function identity<T>() : Pulse<T> -> Propagation<T> {
		return function(pulse : Pulse<T>) : Propagation<T> {
			return Propagate(pulse);
		}
	}
}
