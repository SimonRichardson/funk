package funk.types;

import funk.collections.Collection;
import funk.collections.CollectionUtil;
import funk.collections.immutable.List;
import funk.collections.immutable.ListUtil;
import funk.types.Any;
import funk.types.Wildcard;

enum WildcardType {
    _;
}

abstract Wildcard(WildcardType) from WildcardType to WildcardType {

	inline function new(wildcard : WildcardType) {
		this = wildcard;
	}

	@:to
	inline public static function toString(wildcard : WildcardType) : String {
		return '_';
	}
}

class WildcardTypes {

    public static function toBoolean<T>(wildcard : Wildcard, x : Null<T>) : Bool {
        return AnyTypes.toBool(x);
    }

    public static function toCollection<T>(wildcard : Wildcard, x : T) : Collection<T> {
        return CollectionUtil.toCollection(x);
    }

    public static function toList<T>(wildcard : Wildcard, x : T) : List<T> {
        return ListUtil.toList(x);
    }

    public static function toLowerCase<T>(wildcard : Wildcard, x : T) : String {
        return toString(wildcard, x).toLowerCase();
    }

    public static function toString<T>(wildcard : Wildcard, x : T) : String {
        return AnyTypes.toString(x);
    }

    public static function toUpperCase<T>(wildcard : Wildcard, x : T) : String {
        return toString(wildcard, x).toUpperCase();
    }

    public static function plus_(wildcard : Wildcard, a : Dynamic, b : Dynamic) : Dynamic {
        return a + b;
    }

    public static function minus_(wildcard : Wildcard, a : Dynamic, b : Dynamic) : Dynamic {
        return a - b;
    }

    public static function multiply_( wildcard : Wildcard, a : Dynamic, b : Dynamic) : Dynamic {
        return a * b;
    }

    public static function divide_(wildcard : Wildcard, a : Dynamic, b : Dynamic) : Dynamic {
        return a / b;
    }

    public static function modulo_(wildcard : Wildcard, a : Dynamic, b : Dynamic) : Dynamic {
        return a % b;
    }

    public static function lessThan_(wildcard : Wildcard, a : Dynamic, b : Dynamic) : Bool {
        return a < b;
    }

    public static function lessEqual_(wildcard : Wildcard, a : Dynamic, b : Dynamic) : Bool {
        return a <= b;
    }

    public static function greaterThan_(  wildcard : Wildcard, a : Dynamic, b : Dynamic) : Bool {
        return a > b;
    }

    public static function greaterEqual_( wildcard : Wildcard, a : Dynamic, b : Dynamic) : Bool {
        return a >= b;
    }

    public static function equal_<T1, T2>(wildcard : Wildcard, a : T1, b : T2) : Bool {
        return AnyTypes.equals(a, b);
    }

    public static function notEqual_<T1, T2>(wildcard : Wildcard, a : T1, b : T2) : Bool {
        return !AnyTypes.equals(a, b);
    }

    public static function binaryAnd_(wildcard : Wildcard, a : Int, b : Int) : Int {
        return a & b;
    }

    public static function binaryXor_(wildcard : Wildcard, a : Int, b : Int) : Int {
        return a ^ b;
    }
}
