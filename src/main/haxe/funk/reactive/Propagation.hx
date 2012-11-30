package funk.reactive;

enum Propagation<T> {
	Negate;
    Propagate(value: Pulse<T>);
}
