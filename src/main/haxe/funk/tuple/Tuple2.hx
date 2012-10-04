package funk.tuple;

import funk.product.Product2;
import funk.tuple.Tuple;
import funk.errors.NoSuchElementError;

interface ITuple2<T1, T2> implements ITuple {

	var _1(dynamic, never) : T1;
	var _2(dynamic, never) : T2;
}

enum Tuple2<T1, T2> {
	tuple2(t1 : T1, t2 : T2);
}

class Tuple2Type {

	inline public static function _1<T1, T2>(tuple : Tuple2<T1, T2>) : T1 {
		return switch(tuple) {
			case tuple2(t1, t2): t1;
		}
	}

	inline public static function _2<T1, T2>(tuple : Tuple2<T1, T2>) : T2 {
		return switch(tuple) {
			case tuple2(t1, t2): t2;
		}
	}

	inline public static function instance<T1, T2>(tuple : Tuple2<T1, T2>) : ITuple2<T1, T2> {
		return switch(tuple) {
			case tuple2(t1, t2): new Tuple2Impl<T1, T2>(t1, t2);
		}
	}
}

class Tuple2Impl<T1, T2> extends Product2<T1, T2>, implements ITuple2<T1, T2> {

	public var _1(get__1, never) : T1;
	public var _2(get__2, never) : T2;

	private var __1 : T1;
	private var __2 : T2;

	public function new(_1 : T1, _2 : T2) {
		super();

		__1 = _1;
		__2 = _2;
	}

	override public function productElement(index : Int) : Dynamic {
		return switch(index) {
			case 0: cast __1;
			case 1: cast __2;
			default: throw new NoSuchElementError();
		};
	}

	private function get__1() : T1 {
		return __1;
	}

	private function get__2() : T2 {
		return __2;
	}

	override private function get_productArity() : Int {
		return 2;
	}

	override private function get_productPrefix() : String {
		return "Tuple2";
	}
}
