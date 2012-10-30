package funk;

import funk.option.Any;

using funk.option.Any;

class Pass {

	public static function any<T>(value : T) : Void -> T {
		return function() {
			return value;
		};
	}

	public static function string(value : String) : Void -> String {
		return function() {
			return value;
		};
	}

	public static function bool(value : Bool) : Void -> Bool {
		return function() {
			return value;
		};
	}

	public static function int(value : Int) : Void -> Int {
		return function() {
			return value;
		};
	}

	public static function float(value : Float) : Void -> Float {
		return function() {
			return value;
		};
	}

	public static function type<T>(value : Class<T>) : Void -> Class<T> {
		return function() {
			return value;
		};
	}

	public static function instanceOf<T>(value : Class<T>, ?args : Array<Dynamic> = null) : Void -> T {
		return function() {
			return Type.createInstance(value, args.getOrElse(function() {
				return [];
			}));
		}
	}

}