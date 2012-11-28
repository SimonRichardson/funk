package funk.types.extensions;

import funk.types.Function1;
import funk.types.Predicate2;

class Anys {

	public static function equals<T1, T2>(value0 : T1, value1 : T2, ?func : Predicate2<T1, T2>) : Bool {
		// TODO (Simon) : Infer the type, so we can do better matching.
		return null != func ? func(value0, value1) : cast(value0) == cast(value1);
	}

	public static function toString<T>(value : T, func : Function1<T, String>) : String {
		return null != func ? func(value) : Std.string(value);
	}
}
