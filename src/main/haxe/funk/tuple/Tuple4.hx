package funk.tuple;

import funk.product.Product;
import funk.tuple.Tuple;
import funk.errors.NoSuchElementError;

interface ITuple4<A, B, C, D> implements ITuple {
	
	var _1(dynamic, never) : A;
	var _2(dynamic, never) : B;
	var _3(dynamic, never) : C;
	var _4(dynamic, never) : D;
}

enum Tuple4<A, B, C, D> {
	tuple4(a : A, b : B, c : C, d : D);
}

class Tuple4Type {
	
	inline public static function _1<A, B, C, D>(tuple : Tuple4<A, B, C, D>) : A {
		return switch(tuple) {
			case tuple4(a, b, c, d): a;
		}
	}
	
	inline public static function _2<A, B, C, D>(tuple : Tuple4<A, B, C, D>) : B {
		return switch(tuple) {
			case tuple4(a, b, c, d): b;
		}
	}
	
	inline public static function _3<A, B, C, D>(tuple : Tuple4<A, B, C, D>) : C {
		return switch(tuple) {
			case tuple4(a, b, c, d): c;
		}
	}
	
	inline public static function _4<A, B, C, D>(tuple : Tuple4<A, B, C, D>) : D {
		return switch(tuple) {
			case tuple4(a, b, c, d): d;
		}
	}
	
	inline public static function instance<A, B, C, D>(tuple : Tuple4<A, B, C, D>) : ITuple4<A, B, C, D> {
		return switch(tuple) {
			case tuple4(a, b, c, d): new Tuple4Impl<A,B,C,D>(a, b, c, d);
		}
	}
}

class Tuple4Impl<A, B, C, D> extends Product, implements ITuple4<A, B, C, D> {
	
	public var _1(get__1, never) : A;
	public var _2(get__2, never) : B;
	public var _3(get__3, never) : C;
	public var _4(get__4, never) : D;
	
	private var __1 : A;
	private var __2 : B;
	private var __3 : C;
	private var __4 : D;
	
	public function new(_1 : A, _2 : B, _3 : C, _4 : D) {
		super();
		
		__1 = _1;
		__2 = _2;
		__3 = _3;
		__4 = _4;
	}
	
	override public function productElement(index : Int) : Dynamic {
		return switch(index) {
			case 0: __1;
			case 1: cast __2;
			case 2: cast __3;
			case 3: cast __4;
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
	
	private function get__4() : D {
		return __4;
	}
	
	override private function get_productArity() : Int {
		return 4;
	}
}