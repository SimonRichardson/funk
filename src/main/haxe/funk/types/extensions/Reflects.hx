package funk.types.extensions;

import funk.Funk;

using Lambda;

class Reflects {

	public static function hasMethod<T>(value : T, methodName : String) : Bool {
		return if (null != Reflect.field(value, methodName)) {
			true;
		} else {
			hasInstanceMethod(Type.getClass(value), methodName);
		}
	}

	public static function hasInstanceMethod<T>(value : Class<T>, methodName : String) : Bool {
		return Type.getInstanceFields(value).indexOf(methodName) >= 0;
	}
}
