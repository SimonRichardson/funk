package funk.types;

typedef Product<T> = {> Iterable<T>,

	function productArity() : Int;

	function productPrefix() : String;

	function productElement(index : Int) : T;
};
