package funk.tuple;

import funk.product.Product2;
import funk.tuple.Tuple;
import funk.errors.NoSuchElementError;

interface ITuple2<A, B> implements ITuple {
	
	var _1(dynamic, never) : A;
	var _2(dynamic, never) : B;
}

enum Tuple2<A, B> {
	tuple2(a : A, b : B);
}

class Tuple2Type {
	
	inline public static function _1<A, B>(tuple : Tuple2<A, B>) : A {
		return switch(tuple) {
			case tuple2(a, b): a;
		}
	}
	
	inline public static function _2<A, B>(tuple : Tuple2<A, B>) : B {
		return switch(tuple) {
			case tuple2(a, b): b;
		}
	}
}

class Tuple2Impl<A, B> extends Product2<A, B>, implements ITuple2<A, B> {
	
	public var _1(get__1, never) : A;
	public var _2(get__2, never) : B;
	
	private var __1 : A;
	private var __2 : B;
	
	public function new(_1 : A, _2 : B) {
		super();
		
		__1 = _1;
		__2 = _2;
	}
	
	override public function productElement(index : Int) : Dynamic {
		return switch(index) {
			case 0: __1;
			case 1: cast __2;
			default: throw new NoSuchElementError();
		};
	}
	
	private function get__1() : A {
		return __1;
	}
	
	private function get__2() : B {
		return __2;
	}
	
	override private function get_productArity() : Int {
		return 2;
	}
}
