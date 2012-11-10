package funk;

import funk.collections.IList;
import funk.collections.immutable.ListUtil;

enum Wildcard {
	_;
}

class Wildcards {

	inline public static function toBoolean<T>(wildcard : Wildcard, x : T) : Bool {
		return if (x == null) {
      		false;
    	} else {
      		Std.is(x, Bool) ? !!(cast(x, Bool)) : true;
    	}
	}

	inline public static function toList<T>(wildcard : Wildcard, x : T) : IList<T> {
		return ListUtil.toList(x);
	}

	inline public static function toLowerCase<T>(wildcard : Wildcard, x : T) : String {
		return toString(wildcard, x).toLowerCase();
	}

	inline public static function toString<T>(wildcard : Wildcard, x : T) : String {
		return x + "";
	}

	inline public static function toUpperCase<T>(wildcard : Wildcard, x : T) : String {
		return toString(wildcard, x).toUpperCase();
	}

	inline public static function plus_(wildcard : Wildcard, a : Dynamic, b : Dynamic) : Dynamic {
		return a + b;
	}

	inline public static function minus_(wildcard : Wildcard, a : Dynamic, b : Dynamic) : Dynamic {
		return a - b;
	}

	inline public static function multiply_(wildcard : Wildcard, a : Dynamic, b : Dynamic) : Dynamic {
		return a * b;
	}

	inline public static function divide_(wildcard : Wildcard, a : Dynamic, b : Dynamic) : Dynamic {
		return a / b;
	}

	inline public static function modulo_(wildcard : Wildcard, a : Dynamic, b : Dynamic) : Dynamic {
		return a % b;
	}

	inline public static function lessThan_(wildcard : Wildcard, a : Dynamic, b : Dynamic) : Bool {
		return a < b;
	}

	inline public static function lessEqual_(wildcard : Wildcard, a : Dynamic, b : Dynamic) : Bool {
		return a <= b;
	}

	inline public static function greaterThan_(wildcard : Wildcard, a : Dynamic, b : Dynamic) : Bool {
		return a > b;
	}

	inline public static function greaterEqual_(wildcard : Wildcard, a : Dynamic, b : Dynamic) : Bool {
		return a >= b;
	}

	inline public static function equal_<T>(wildcard : Wildcard, a : T, b : T) : Bool {
		return if(a == b) {
			true;
		} else if(Std.is(a, IFunkObject) && Std.is(b, IFunkObject)) {
			var funk0 : IFunkObject = cast a;
			var funk1 : IFunkObject = cast b;
			funk0.equals(funk1);
		} else {
			false;
		}
	}

	inline public static function notEqual_<T>(wildcard : Wildcard, a : T, b : T) : Bool {
		return !equal_(wildcard, a, b);
	}

	inline public static function binaryAnd_(wildcard : Wildcard, a : Int, b : Int) : Int {
		return a & b;
	}

	inline public static function binaryXor_(wildcard : Wildcard, a : Int, b : Int) : Int {
		return a ^ b;
	}
}
