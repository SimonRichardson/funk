package funk.types;

enum Option<T> {
	None;
	Some(value : T);
}