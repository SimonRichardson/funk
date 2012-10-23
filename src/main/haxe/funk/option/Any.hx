package funk.option;

import funk.option.Option;

class Anys {

	inline public static function get<T>(type : T) : T {
		return type;
	}

	inline public static function getThen<T>(type : T, func : T -> T) : T {
		return type != null ? func(type) : type;
	}

	inline public static function getOrElse<T>(type : T, func : Void -> T) : T {
		return type != null ? type : func();
	}

	inline public static function isDefined<T>(type : T) : Bool {
		return type != null;
	}

	inline public static function isEmpty<T>(type : T) : Bool {
		return type == null;
	}

	inline public static function orElse<T>(type : T, alt : T) : T {
		return type != null ? type : alt;
	}

	inline public static function toOption<T>(value : T) : Option<T> {
		return Anys.isEmpty(value) ? None : Some(value);
	}

	public static function equals<T1, T2>(value0 : T1, value1 : T2) : Bool {
		return if(Type.typeof(value0) == Type.typeof(value1) && (cast value0) == (cast value1)) {
			true;
		} else if(Std.is(value0, IFunkObject) && Std.is(value1, IFunkObject)) {
			var funk0 : IFunkObject = cast value0;
			var funk1 : IFunkObject = cast value1;

			funk0.equals(funk1);
		} else {
			// TODO (Simon) : work out if they're enums
			false;
		}
	}
}
