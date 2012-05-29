package funk;

import funk.collections.IList;
import funk.collections.immutable.ListUtil;
import funk.macro.WildcardMacro;
import funk.unit.Expect;

using funk.unit.Expect;

enum Wildcard {
	_;
}

@:build(funk.macro.WildcardMacro.build()) 
class WildcardType {
	
	public static function invoke<T, E>(wildcard : Wildcard, name : String) : T -> E {
		return function(x : T) : E {
			return Reflect.callMethod(x, Reflect.field(x, name), []);
		}
	}
	
	inline public static function binaryNot(value : Int) : Int {
		return ~value;
	}
	
	public static function decrementBy(wildcard : Wildcard, value : Float) : Float -> Float {
		return function(x : Float) : Float {
			return x - value;
		}
	}
	
	public static function divideBy(wildcard : Wildcard, value : Float) : Float -> Float {
		return function(x : Float) : Float {
			return x / value;
		}
	}
	
	public static function equals<T, E>(wildcard : Wildcard, value : T) : E -> Bool {
		return function(x : E) : Bool {
			return expect(x).toEqual(value);
		}
	}
	
	public static function get<T, E>(wildcard : Wildcard, value : String) : T -> E {
		return function(x : T) : E {
			return Reflect.getProperty(x, value);
		}
	}
	
	public static function greaterEqual(wildcard : Wildcard, value : Float) : Float -> Bool {
		return function(x : Float) : Bool {
			return x >= value;
		}
	}
	
	public static function greaterThan(wildcard : Wildcard, value : Float) : Float -> Bool {
		return function(x : Float) : Bool {
			return x > value;
		}
	}
	
	public static function incrementBy(wildcard : Wildcard, value : Float) : Float -> Float {
		return function(x : Float) : Float {
			return x + value;
		}
	}
	
	public static function inRange(wildcard : Wildcard, min : Float, max : Float) : Float -> Bool {
		return function(x : Float) : Bool {
			return min <= x && x <= max;
		}
	}
	
	inline public static function isEven(wildcard : Wildcard, x : Float) : Bool {
		var asInt: Int = cast(x, Int);
		return if(0 != (x - asInt)) { false; } else { (asInt & 1) == 0; }
	}
	
	inline public static function isOdd(wildcard : Wildcard, x : Float) : Bool {
		var asInt: Int = cast(x, Int);
		return if(0 != (x - asInt)) { false; } else { (asInt & 1) != 0; }
	}
	
	public static function lessEqual(wildcard : Wildcard, value : Float) : Float -> Bool {
		return function(x : Float) : Bool {
			return x <= value;
		}
	}
	
	public static function lessThan(wildcard : Wildcard, value : Float) : Float -> Bool {
		return function(x : Float) : Bool {
			return x < value;
		}
	}
	
	public static function moduloBy(wildcard : Wildcard, value : Float) : Float -> Float {
		return function(x : Float) : Float {
			return x % value;
		}
	}
	
	public static function multiplyBy(wildcard : Wildcard, value : Float) : Float -> Float {
		return function(x : Float) : Float {
			return x * value;
		}
	}
	
	inline public static function not<T>(wildcard : Wildcard, x : T) : Bool {
		return !toBoolean(wildcard, x);
	}
	
	public static function notEquals<T, E>(wildcard : Wildcard, value : T) : E -> Bool {
		return function(x : E) : Bool {
			return expect(x).toNotEqual(value);
		}
	}
	
	inline public static function toList<T>(wildcard : Wildcard, x : T) : IList<T> {
		return ListUtil.toList(x);
	}
	
	inline public static function toBoolean<T>(wildcard : Wildcard, x : T) : Bool {
		if(x == null) {
			return false;
		} else if(Std.is(x, Bool)) {
			var b : Bool = cast x;
			return b;
		} else {
			return true;
		}
	}
	
	inline public static function toLowerCase<T>(wildcard : Wildcard, x : T) : String {
		return toString(wildcard, x).toLowerCase();
	}
	
	inline public static function toString<T>(wildcard : Wildcard, x : T) : String {
		return (Std.is(x, String) ? cast(x) : x + "");
	}
	
	inline public static function toUpperCase<T>(wildcard : Wildcard, x : T) : String {
		return toString(wildcard, x).toUpperCase();
	}
	
	inline public static function plus_(wildcard : Wildcard, a : Dynamic, b : Dynamic) : Dynamic {
		return a + b;
	}
	
	inline public static function minus_(wildcard : Wildcard, a : Float, b : Float) : Float {
		return a - b;
	}
	
	inline public static function multiply_(wildcard : Wildcard, a : Float, b : Float) : Float {
		return a * b;
	}
	
	inline public static function divide_(wildcard : Wildcard, a : Float, b : Float) : Float {
		return a / b;
	}
	
	inline public static function modulo_(wildcard : Wildcard, a : Float, b : Float) : Float {
		return a % b;
	}
	
	inline public static function lessThan_(wildcard : Wildcard, a : Float, b : Float) : Bool {
		return a < b;
	}
	
	inline public static function lessEqual_(wildcard : Wildcard, a : Float, b : Float) : Bool {
		return a <= b;
	}
	
	inline public static function greaterThan_(wildcard : Wildcard, a : Float, b : Float) : Bool {
		return a > b;
	}
	
	inline public static function greaterEqual_(wildcard : Wildcard, a : Float, b : Float) : Bool {
		return a >= b;
	}
	
	inline public static function equal_<T>(wildcard : Wildcard, a : T, b : T) : Bool {
		return expect(a).toEqual(b);
	}
	
	inline public static function notEqual_<T>(wildcard : Wildcard, a : T, b : T) : Bool {
		return expect(a).toNotEqual(b);
	}
	
	inline public static function binaryAnd_(wildcard : Wildcard, a : Int, b : Int) : Int {
		return a & b;
	}
	
	inline public static function binaryXor(wildcard : Wildcard, a : Int, b : Int) : Int {
		return a ^ b;
	}
}