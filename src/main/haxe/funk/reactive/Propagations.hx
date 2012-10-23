package funk.reactive;

import funk.reactive.Propagation;

class Propagations {

	public static function indentity<T>() : Pulse<T> -> Propagation<T> {
		return function(pulse : Pulse<T>) : Propagation<T> {
			return if(pulse.value) {
				Propagate(pulse);
			} else {
				Negate;
			}
		}
	}
}
