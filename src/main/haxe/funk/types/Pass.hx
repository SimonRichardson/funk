package funk.types;

import funk.types.extensions.Reflects;

class Pass {

	public static function instanceOf<T>(type : Class<T>) : Function0<T> {
		return function() : T {
			return Reflects.createEmptyInstance(type);
		};
	}
}