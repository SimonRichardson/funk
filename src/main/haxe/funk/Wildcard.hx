package funk;

enum Wildcard {
	_;
}

class WildcardType {
	
	inline public static function binaryNot<T>(value : T) : T {
		return ~value;
	}
	
	public static function decrementBy(wildcard : Wildcard, value : Float) : Float -> Float {
		return function(x : Float) : Float {
			return x - value;
		}
	}
	
	public static function divideBy<T, E>(wildcard : Wildcard, value : T) : E -> T {
		return function(x : E) : T {
			return x / value;
		}
	}
	
	public static function equals<T, E>(wildcard : Wildcard, value : T) : E -> Bool {
		return function(x : E) : Bool {
			return true;
		}
	}
	
	public static function get<T, E>(wildcard : Wildcard, value : String) : T -> E {
		return function(x : T) : E {
			return Reflect.getProperty(x, value);
		}
	}
	
	public static function greaterEqual<T, E>(wildcard : Wildcard, value : T) : E -> Bool {
		return function(x : E) : Bool {
			return x >= value;
		}
	}
	
	public static function greaterThan<T, E>(wildcard : Wildcard, value : T) : E -> Bool {
		return function(x : E) : Bool {
			return x > value;
		}
	}
	
	public static function incrementBy<T, E>(wildcard : Wildcard, value : T) : E -> Bool {
		return function(x : E) : Bool {
			return x + value;
		}
	}
	
	public static function inRange<T, E>(wildcard : Wildcard, min : T, max : T) : E -> Bool {
		return function(x : E) : Bool {
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
	
	public static function lessEqual<T, E>(wildcard : Wildcard, value : T) : E -> T {
		return function(x : E) : Bool {
			return x <= value;
		}
	}
	
	public static function lessThan<T, E>(wildcard : Wildcard, value : T) : E -> T {
		return function(x : E) : Bool {
			return x < value;
		}
	}
	
	public static function moduloBy<T, E>(wildcard : Wildcard, value : T) : E -> T {
		return function(x : E) : Bool {
			return x % value;
		}
	}
	
	public static function multiplyBy<T, E>(wildcard : Wildcard, value : T) : E -> T {
		return function(x : E) : Bool {
			return x * value;
		}
	}
	
	inline public static function not<T>(wildcard : Wildcard, x : T) : Bool {
		return !x;
	}
	
	public static function notEquals<T, E>(wildcard : Wildcard, value : T) : E -> Bool {
		return function(x : E) : Bool {
			return true;
		}
	}
	
	inline public static function toBoolean<T>(wildcard : Wildcard, x : T) : Bool {
		return x ? true : false;
	}
	
	inline public static function toLowerCase<T>(wildcard : Wildcard, x : T) : String {
		return Std.is(x, String) ? cast(x).toLowerCase() : (x + "").toLowerCase();
	}
}