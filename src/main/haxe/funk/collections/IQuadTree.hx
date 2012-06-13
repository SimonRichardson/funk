package funk.collections;

import funk.option.Option;
import funk.product.Product;

typedef IQuadTreePoint = {
	var x : Float;
	var y : Float;
};

typedef IQuadTreeRectangle = {
	var x : Float;
	var y : Float;
	var width : Float;
	var height : Float;
};

interface IQuadTree<T> implements IProduct, implements ICollection<T> {
	
	var rect(dynamic, dynamic) : IQuadTreeRectangle;

	function add(value : T) : IQuadTree<T>;

	function addAt(value : T, index: Int) : IQuadTree<T>;

	function remove(value : T) : IQuadTree<T>;

	function removeAt(value : Int) : IQuadTree<T>;

	function get(value : T) : Option<T>;

	function getAt(index : Int) : Option<T>;

	function contains(value : T) : Bool;

	function indexOf(value : T) : Int;

	function integrate() : Void;

	function queryPoint(value : IQuadTreePoint) : IList<T>;

	function queryRectangle(value : IQuadTreeRectangle) : IList<T>;
}