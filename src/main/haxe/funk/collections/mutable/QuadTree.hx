package funk.collections.mutable;

import funk.collections.IList;
import funk.collections.IQuadTree;
import funk.collections.mutable.Nil;
import funk.unit.Expect;

using funk.collections.mutable.Nil;
using funk.unit.Expect;

class QuadTree<T> implements IQuadTree<T> {

	private static var MAX_RECURSION : Int = 4;

	public var width(get_width, set_width) : Float;

	public var height(get_height, set_height) : Float;

	private var _quad : QuadTreeNode<T>;

	private var _nodes : IList<T>;

	public function new(width : Float, height : Float) {
		_nodes = nil.list();
		_quad = new QuadTreeNode<T>({x: 0, y: 0, width: 0, height: 0}, MAX_RECURSION);
	}

	public function add(value : T) : IQuadTree<T> {
		_nodes = _nodes.prepend(value);
		return this;
	}

	public function remove(value : T) : IQuadTree<T> {
		_nodes = _nodes.filterNot(function(v : T) : Bool {
			return expect(value).toEqual(v);
		});
		return this;
	}

	public function queryPoint(value : QuadTreePoint) : IList<T> {
		return switch(_quad.queryPoint(value)){
			case Some(x): x.nodes;
			case None: nil.list();
		}
	}

	public function queryRectangle(value : QuadTreeRectangle) : IList<T> {
		return switch(_quad.queryRectangle(value)){
			case Some(x): x.nodes;
			case None: nil.list();
		}
	}

	public function integrate() : Void {
		_quad.clearAll();

		for(n in _nodes) {
			_quad.add(n);
		}
	}

	public function iterator() : Iterator<T> {
		return _nodes.iterator();
	}

	private function get_width() : Float {
		return _quad.width;
	}

	private function set_width(value : Float) : Float {
		_quad.width = value;
		return value;
	}

	private function get_height() : Float {
		return _quad.height;
	}

	private function set_height(value : Float) : Float {
		_quad.height = value;
		return value;
	}
}

private class QuadTreeNode<T> {

	public var x(get_x, set_x) : Float;

	public var y(get_y, set_y) : Float;

	public var width(get_width, set_width) : Float;

	public var height(get_height, set_height) : Float;

	private var _rect : QuadTreeRectangle;

	private var _level : Int;

	private var _leaf : Bool;

	private var _q0 : QuadTreeNode<T>;

	private var _q1 : QuadTreeNode<T>;

	private var _q2 : QuadTreeNode<T>;

	private var _q3 : QuadTreeNode<T>;

	public function new(rect : QuadTreeRectangle, level : Int) {
		_rect = rect;
		_level = level;

		_leaf = if(level > 0) {
			var l : Int = level - 1;

			var qx : Float = _rect.x;
			var qy : Float = _rect.y;
			var qw : Float = _rect.width * 0.5;
			var qh : Float = _rect.height * 0.5;

			_q0 = new QuadTreeNode<T>({x: qx, y: qy, width: qw, height: qh}, l);
			_q1 = new QuadTreeNode<T>({x: qx + qw, y: qy, width: qw, height: qh}, l);
			_q2 = new QuadTreeNode<T>({x: qx, y: qy + qh, width: qw, height: qh}, l);
			_q3 = new QuadTreeNode<T>({x: qx + qw, y: qy + qh, width: qw, height: qh}, l);

			false;
		} else {
			_nodes = nil.list();
			true;
		}
	}

	public function add(value : T) : Void {
		if(_leaf) {
			_nodes = _nodes.prepend(value);
		} else {
			var bounds : QuadTreeRectangle = value.bounds;
			if(_q0.rect.intersects(bounds)) {
				_q0.add(value);
			}

			if(_q1.rect.intersects(bounds)) {
				_q1.add(value);
			}

			if(_q2.rect.intersects(bounds)) {
				_q2.add(value);
			}

			if(_q3.rect.intersects(bounds)) {
				_q3.add(value);
			}
		}
	}

	public function clearAll() : Void {
		if(_leaf) {
			_nodes = nil.list();
		} else {
			_q0.clearAll();
			_q1.clearAll();
			_q2.clearAll();
			_q3.clearAll();
		}
	}

	public function queryPoint(value : QuadTreePoint) : IOption<QuadTreeNode> {
		return if(_leaf) {
			_rect.containsPoint(value) ? Some(this) : None;
		} else {
			if(_q0.rect.containsPoint(value)) {
				_q0.queryPoint(value);
			} else if(_q1.rect.containsPoint(value)) {
				_q1.queryPoint(value);
			} else if(_q2.rect.containsPoint(value)) {
				_q2.queryPoint(value);
			} else if(_q3.rect.containsPoint(value)) {
				_q3.queryPoint(value);
			} else {
				None;
			}
		}
	}

	public function queryRectangle(value : QuadTreeRectangle) : IOption<QuadTreeNode> {
		return if(_leaf) {
			_rect.intersects(value) ? Some(this) : None;
		} else {
			if(_q0.rect.intersects(value)) {
				_q0.queryRectangle(value);
			} else if(_q1.rect.intersects(value)) {
				_q1.queryRectangle(value);
			} else if(_q2.rect.intersects(value)) {
				_q2.queryRectangle(value);
			} else if(_q3.rect.intersects(value)) {
				_q3.queryRectangle(value);
			} else {
				None;
			}
		}
	}

	public function iterator() : Iterator<T> {
		return _nodes.iterator();
	}

	public function nodes() : IList<T> {
		return _nodes;
	}

	private function rect() : QuadTreeRectangle {
		return _rect;
	}

	private function get_x() : Float {
		return _rect.x;
	}

	private function set_x(value : Float) : Float {
		_rect.x = value;
		return value;
	}

	private function get_y() : Float {
		return _rect.y;
	}

	private function set_y(value : Float) : Float {
		_rect.y = value;
		return _rect;
	}

	private function get_width() : Float {
		return _rect.width;
	}

	private function set_width(value : Float) : Float {
		_rect.width = value;

		if(!_leaf) {
			var qw : Float = _rect.width * 0.5;

			_q0.width = qw;
			_q1.width = qw;
			_q2.width = qw;
			_q3.width = qw;

			_q1.x = qw;
			_q3.x = qw;
		}
		return value;
	}

	private function get_height() : Float {
		return _rect.height;
	}

	private function set_height(value : Float) : Float {
		_rect.height = value;

		if(!_leaf) {
			var qh : Float = _rect.height * 0.5;

			_q0.height = qh;
			_q1.height = qh;
			_q2.height = qh;
			_q3.height = qh;

			_q2.y = qh;
			_q3.y = qh;
		}
		return _rect;
	}
}