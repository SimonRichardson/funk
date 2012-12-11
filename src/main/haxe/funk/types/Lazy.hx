package funk.types;

enum Lazy<T> {
	lazy(func : Function0<T>);
}
