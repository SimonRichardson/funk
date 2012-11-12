package funk;

import funk.Funk;
import funk.option.Any;

using funk.option.Any;

class Pass {

	public static function any<T>(value : T) : Function0<T> {
		return function() {
			return value;
		};
	}

	public static function string(value : String) : Function0<String> {
		return function() {
			return value;
		};
	}

	public static function bool(value : Bool) : Function0<Bool> {
		return function() {
			return value;
		};
	}

	public static function int(value : Int) : Function0<Int> {
		return function() {
			return value;
		};
	}

	public static function float(value : Float) : Function0<Float> {
		return function() {
			return value;
		};
	}

	public static function type<T>(value : Class<T>) : Function0<Class<T>> {
		return function() {
			return value;
		};
	}

	public static function instanceOf<T>(value : Class<T>, ?args : Array<Dynamic> = null) : Function0<T> {
		return function() {
			return Type.createInstance(value, args.getOrElse(function() {
				return [];
			}));
		}
	}
}