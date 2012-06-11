package funk.collections;

import funk.option.Option;
import funk.product.Product;

interface IQuadTree<T> implements IProduct, implements ICollection<T> {
	
	var width(dynamic, dynamic) : Float;

	var height(dynamic, dynamic) : Float;

	function add(value : T) : IQuadTree<T>;

	function addAt(value : T, index: Int) : IQuadTree<T>;

	function remove(value : T) : IQuadTree<T>;

	function removeAt(value : Int) : IQuadTree<T>;

	function get(value : T) : Option<T>;

	function getAt(index : Int) : Option<T>;

	function contains(value : T) : Bool;

	function indexOf(value : T) : Int;

	function integrate() : Void;
}