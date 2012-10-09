package funk.option;

import funk.option.Option;

class Anys {

	inline public static function get<T>(type : T) : T {
		return type;
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

	inline public static function equals<T1, T2>(value0 : T1, value1 : T2) : Bool {
		return if(value0 == value1) {
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
