package funk.types;

using funk.types.Function0;
using funk.types.Option;

typedef Lazy<T> = Function0<T>;

class Lazys {

    public static function lazy<R>(func : Lazy<R>) : Function0<R> {
        var value : R = null;

        return function() {
            if (value == null) {
                value = func();
            }
            return value;
        };
    }
}
