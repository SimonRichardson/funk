package funk.types;

import haxe.ds.Option;

typedef Product<T> = {> Iterable<T>,

	function productArity() : Int;

	function productPrefix() : String;

	function productElement(index : Int) : Option<T>;
};
