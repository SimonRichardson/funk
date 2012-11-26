package funk.collections.immutable;

enum List<T> {
	Nil;
	Cons(head : T, tail : List<T>);
}