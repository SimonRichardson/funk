package funk.types.extensions;

import funk.Funk;

class Bools {

	public static function equals(a : Bool, b : Bool) : Bool {
		return a == b;
	}

	public static function is(value : Bool) : Bool {
		return !!value;
	}

	public static function not(value : Bool) : Bool {
		return !value;
	}

	public static function toInt(value : Bool) : Int {
		return value ? 1 : 0;
	}
}
