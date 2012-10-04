package funk.tuple;

import funk.product.Product;
import funk.tuple.Tuple;
import funk.errors.NoSuchElementError;

interface ITuple3<T1, T2, T3> implements ITuple {

	var _1(dynamic, never) : T1;
	var _2(dynamic, never) : T2;
	var _3(dynamic, never) : T3;
}

enum Tuple3<T1, T2, T3> {
	tuple3(t1 : T1, t2 : T2, t3 : T3);
}

class Tuple3Type {

	inline public static function _1<T1, T2, T3>(tuple : Tuple3<T1, T2, T3>) : T1 {
		return switch(tuple) {
			case tuple3(t1, t2, t3): t1;
		}
	}

	inline public static function _2<T1, T2, T3>(tuple : Tuple3<T1, T2, T3>) : T2 {
		return switch(tuple) {
			case tuple3(t1, t2, t3): t2;
		}
	}

	inline public static function _3<T1, T2, T3>(tuple : Tuple3<T1, T2, T3>) : T3 {
		return switch(tuple) {
			case tuple3(t1, t2, t3): t3;
		}
	}

	inline public static function instance<T1, T2, T3>(tuple : Tuple3<T1, T2, T3>)
																	 : ITuple3<T1, T2, T3> {
		return switch(tuple) {
			case tuple3(t1, t2, t3): new Tuple3Impl<T1, T2, T3>(t1, t2, t3);
		}
	}
}

class Tuple3Impl<T1, T2, T3> extends Product3<T1, T2, T3>, implements ITuple3<T1, T2, T3> {

	public var _1(get__1, never) : T1;
	public var _2(get__2, never) : T2;
	public var _3(get__3, never) : T3;

	private var __1 : T1;
	private var __2 : T2;
	private var __3 : T3;

	public function new(_1 : T1, _2 : T2, _3 : T3) {
		super();

		__1 = _1;
		__2 = _2;
		__3 = _3;
	}

	override public function productElement(index : Int) : Dynamic {
		return switch(index) {
			case 0: cast __1;
			case 1: cast __2;
			case 2: cast __3;
			default: throw new NoSuchElementError();
		};
	}

	private function get__1() : T1 {
		return __1;
	}

	private function get__2() : T2 {
		return __2;
	}

	private function get__3() : T3 {
		return __3;
	}

	override private function get_productArity() : Int {
		return 3;
	}

	override private function get_productPrefix() : String {
		return "Tuple3";
	}
}
