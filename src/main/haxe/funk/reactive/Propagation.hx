package funk.reactive;

enum Propagation<T> {
	Negate;
    Propagate(value: Pulse<T>);
}

class PropagationTypes {

	public static function identity<T>() : Function1<Pulse<T>, Propagation<T>> {
		return function(pulse : Pulse<T>) : Propagation<T> {
			return Propagate(pulse);
		}
	}
}
