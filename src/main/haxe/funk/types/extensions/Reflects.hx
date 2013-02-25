package funk.types.extensions;

import funk.Funk;
import funk.types.Option;

using Lambda;

class Reflects {

    public static function getClassName<T>(value : T) : String {
        return Type.getClassName(Type.getClass(value));
    }

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

	public static function createEmptyInstance<T>(type : Class<T>) : T {
		return createInstance(type, []);
	}

    public static function createInstance<T>(type : Class<T>, args : Array<Dynamic>) : T {
        // Cover the native std types.
        function capture(type : Class<Dynamic>, args : Array<Dynamic>, defaultValue : Dynamic) : Dynamic {
            return if (args.length == 1 && Std.is(args[0], type)) {
                args[0];
            } else {
                defaultValue;
            }
        };

        return switch (Type.typeof(type)) {
            case TObject:
                switch (Type.getClassName(type)) {
                    case 'Float': capture(Float, args, 0.0);
                    case 'Int': capture(Int, args, 0);
                    case 'String': capture(String, args, new String(""));
                    case _: cast Type.createInstance(type, args);
                }
            default:
                throw "Invalid class to create instance of";
        }
    }
}
