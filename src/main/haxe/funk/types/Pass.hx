package funk.types;

import funk.types.Any;

class Pass {

    public static function instanceOf<T>(type : Class<T>, ?args : Array<Dynamic> = null) : Function0<T> {
        return function() : T {
            return createInstance(type, AnyTypes.toBool(args) ? args : []);
        };
    }

    inline private static function createEmptyInstance<T>(type : Class<T>) : T {
        return createInstance(type, []);
    }

    private static function createInstance<T>(type : Class<T>, args : Array<Dynamic>) : T {
        // Cover the native std types.
        function capture(type : Dynamic, args : Array<Dynamic>, defaultValue : Dynamic) : Dynamic {
            return if (args.length == 1 && AnyTypes.isInstanceOf(args[0], type)) {
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
            case _: throw "Invalid class to create instance of";
        }
    }
}
