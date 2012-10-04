package funk.tuple;

import funk.product.Product4;
import funk.tuple.Tuple;
import funk.errors.NoSuchElementError;

interface ITuple4<T1, T2, T3, T4> implements ITuple {

	var _1(dynamic, never) : T1;
	var _2(dynamic, never) : T2;
	var _3(dynamic, never) : T3;
	var _4(dynamic, never) : T4;
}

enum Tuple4<T1, T2, T3, T4> {
	tuple4(t1 : T1, t2 : T2, t3 : T3, t4 : T4);
}

class Tuple4Type {

	inline public static function _1<T1, T2, T3, T4>(tuple : Tuple4<T1, T2, T3, T4>) : T1 {
		return switch(tuple) {
			case tuple4(t1, t2, t3, t4): t1;
		}
	}

	inline public static function _2<T1, T2, T3, T4>(tuple : Tuple4<T1, T2, T3, T4>) : T2 {
		return switch(tuple) {
			case tuple4(t1, t2, t3, t4): t2;
		}
	}

	inline public static function _3<T1, T2, T3, T4>(tuple : Tuple4<T1, T2, T3, T4>) : T3 {
		return switch(tuple) {
			case tuple4(t1, t2, t3, t4): t3;
		}
	}

	inline public static function _4<T1, T2, T3, T4>(tuple : Tuple4<T1, T2, T3, T4>) : T4 {
		return switch(tuple) {
			case tuple4(t1, t2, t3, t4): t4;
		}
	}

	inline public static function instance<T1, T2, T3, T4>(tuple : Tuple4<T1, T2, T3, T4>)
																	 : ITuple4<T1, T2, T3, T4> {
		return switch(tuple) {
			case tuple4(t1, t2, t3, t4): new Tuple4Impl<T1, T2, T3, T4>(t1, t2, t3, t4);
		}
	}
}

class Tuple4Impl<T1, T2, T3, T4> extends Product4<T1, T2, T3, T4>,
								 implements ITuple4<T1, T2, T3, T4> {

	public var _1(get__1, never) : T1;
	public var _2(get__2, never) : T2;
	public var _3(get__3, never) : T3;
	public var _4(get__4, never) : T4;

	private var __1 : T1;
	private var __2 : T2;
	private var __3 : T3;
	private var __4 : T4;

	public function new(_1 : T1, _2 : T2, _3 : T3, _4 : T4) {
		super();

		__1 = _1;
		__2 = _2;
		__3 = _3;
		__4 = _4;
	}

	override public function productElement(index : Int) : Dynamic {
		return switch(index) {
			case 0: cast __1;
			case 1: cast __2;
			case 2: cast __3;
			case 3: cast __4;
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

	private function get__4() : T4 {
		return __4;
	}

	override private function get_productArity() : Int {
		return 4;
	}

	override private function get_productPrefix() : String {
		return "Tuple4";
	}
}
