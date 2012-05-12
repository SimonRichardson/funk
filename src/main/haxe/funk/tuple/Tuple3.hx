package funk.tuple;

import funk.product.Product3;
import funk.tuple.Tuple;
import funk.errors.NoSuchElementError;

interface ITuple3<A, B, C> implements ITuple {
	
	var _1(dynamic, never) : A;
	var _2(dynamic, never) : B;
	var _3(dynamic, never) : C;
}

enum Tuple3<A, B, C> {
	tuple3(a : A, b : B, c : C);
}

class Tuple3Type {
	
	inline public static function _1<A, B, C>(tuple : Tuple3<A, B, C>) : A {
		return switch(tuple) {
			case tuple3(a, b, c): a;
		}
	}
	
	inline public static function _2<A, B, C>(tuple : Tuple3<A, B, C>) : B {
		return switch(tuple) {
			case tuple3(a, b, c): b;
		}
	}
	
	inline public static function _3<A, B, C>(tuple : Tuple3<A, B, C>) : C {
		return switch(tuple) {
			case tuple3(a, b, c): c;
		}
	}
}

class Tuple3Impl<A, B, C> extends Product3<A, B, C>, implements ITuple3<A, B, C> {
	
	public var _1(get__1, never) : A;
	public var _2(get__2, never) : B;
	public var _3(get__3, never) : C;
	
	private var __1 : A;
	private var __2 : B;
	private var __3 : C;
	
	public function new(_1 : A, _2 : B, _3 : C) {
		super();
		
		__1 = _1;
		__2 = _2;
		__3 = _3;
	}
	
	override public function productElement(index : Int) : Dynamic {
		return switch(index) {
			case 0: __1;
			case 1: cast __2;
			case 2: cast __3;
			default: throw new NoSuchElementError();
		};
	}
	
	private function get__1() : A {
		return __1;
	}
	
	private function get__2() : B {
		return __2;
	}
	
	private function get__3() : C {
		return __3;
	}
	
	override private function get_productArity() : Int {
		return 3;
	}
}