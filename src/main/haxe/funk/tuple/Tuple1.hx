package funk.tuple;

import funk.product.Product1;
import funk.tuple.Tuple;
import funk.errors.NoSuchElementError;

interface ITuple1<A> implements ITuple {
	
	var _1(dynamic, never) : A;
}

enum Tuple1<A> {
	tuple1(a : A);
}

class Tuple1Type {
	
	inline public static function _1<A>(tuple : Tuple1<A>) : A {
		return switch(tuple) {
			case tuple1(a): a;
		}
	}
}

class Tuple1Impl<A> extends Product1<A>, implements ITuple1<A> {
	
	public var _1(get__1, never) : A;
	
	private var __1 : A;
	
	public function new(_1 : A) {
		super();
		
		__1 = _1;
	}
	
	override public function productElement(index : Int) : Dynamic {
		return switch(index) {
			case 0: __1;
			default: throw new NoSuchElementError();
		};
	}
	
	private function get__1() : A {
		return __1;
	}
	
	override private function get_productArity() : Int {
		return 1;
	}
}
