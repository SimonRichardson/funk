package funk.collections;

typedef QuadTreePoint = {
	var x : Float;
	var y : Float;
};

typedef QuadTreeRectangle = {
	var x : Float;
	var y : Float;
	var width : Float;
	var height : Float;

	function intersects(rect : QuadTreeRectangle) : Bool;
	function containsPoint(point : QuadTreePoint) : Bool;
};

typedef QuadTarget = {
	var bounds : QuadTreeRectangle;
};

interface IQuadTree<T : QuadTarget> {
	
	var width(dynamic, dynamic) : Float;

	var height(dynamic, dynamic) : Float;

	function add(value : T) : IQuadTree<T>;

	function remove(value : T) : IQuadTree<T>;

	function queryPoint(value : QuadTreePoint) : IList<T>;

	function queryRectangle(value : QuadTreeRectangle) : IList<T>;

	function integrate() : Void;
}