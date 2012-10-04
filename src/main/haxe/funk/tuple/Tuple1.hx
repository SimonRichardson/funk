package funk.tuple;

import funk.product.Product1;
import funk.tuple.Tuple;
import funk.errors.NoSuchElementError;

interface ITuple1<T1> implements ITuple {

	var _1(dynamic, never) : T1;
}

enum Tuple1<T1> {
	tuple1(t1 : T1);
}

class Tuple1Type {

	inline public static function _1<T1>(tuple : Tuple1<T1>) : T1 {
		return switch(tuple) {
			case tuple1(t1): t1;
		}
	}

	inline public static function instance<T1>(tuple : Tuple1<T1>) : ITuple1<T1> {
		return switch(tuple) {
			case tuple1(t1): new Tuple1Impl<T1>(t1);
		}
	}
}

class Tuple1Impl<T1> extends Product1<T1>, implements ITuple1<T1> {

	public var _1(get__1, never) : T1;

	private var __1 : T1;

	public function new(_1 : T1) {
		super();

		__1 = _1;
	}

	override public function productElement(index : Int) : Dynamic {
		return switch(index) {
			case 0: cast __1;
			default: throw new NoSuchElementError();
		};
	}

	private function get__1() : T1 {
		return __1;
	}

	override private function get_productArity() : Int {
		return 1;
	}

	override private function get_productPrefix() : String {
		return "Tuple1";
	}
}
