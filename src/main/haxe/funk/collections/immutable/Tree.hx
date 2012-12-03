package funk.collections.immutable;

enum Tree<T> {
	Branch(children : List<Tree<T>>);
	Leaf(value : Option<T>);
}
