package funk.io.logging;

import funk.types.Any;

class Logging {

    public static function simpleName(value : AnyRef) : String return simpleClassName(Type.getClass(value));

    public static function simpleClassName<T>(value : Class<T>) : String {
        var n = Type.getClassName(value);
        var i = n.lastIndexOf('.');
        return n.substr(i + 1);
    }
}
