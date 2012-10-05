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
}
