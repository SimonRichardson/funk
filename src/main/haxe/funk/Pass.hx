package funk;

import funk.option.Any;

using funk.option.Any;

class Pass {
	
	public static function any<T>(value : T) : Void -> T {
		return function() : T {
			return value;
		};
	}
	
	public static function string(value : String) : Void -> String {
		return function() : String {
			return value;
		};
	}
	
	public static function bool(value : Bool) : Void -> Bool {
		return function() : Bool {
			return value;
		};
	}
	
	public static function integer(value : Int) : Void -> Int {
		return function() : Int {
			return value;
		};
	}
	
	public static function float(value : Float) : Void -> Float {
		return function() : Float {
			return value;
		};
	}
	
	public static function type<T>(value : Class<T>) : Void -> Class<T> {
		return function() : Class<T> {
			return value;
		};
	}
	
	public static function instanceOf<T>(value : Class<T>, ?args : Array<Dynamic> = null) : Void -> T {
		return function() : T {
			return Type.createInstance(value, args.isDefined() ? args : []);
		};
	}
}
