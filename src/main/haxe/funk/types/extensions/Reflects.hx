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

	public static function createEmptyInstance<T>(value : Class<T>) : T {
		// Cover the native std types.
		return switch (Type.typeof(value)) {
			case TObject:
          		switch (Type.getClassName(value)) {
                    case 'Float': cast 0.0;
                    case 'Int': cast 0;
              		case 'String': cast new String("");
              		case 'UInt': cast 0;
              		default: cast Type.createInstance(value, []);
				}
			default: 
				throw "Invalid class to create instance of";
		}
	}
}
