package funk.types;

using funk.types.Function0;
using funk.types.Option;

typedef Lazy<T> = Function0<T>;

class Lazys {

    public static function lazy<R>(func : Lazy<R>) : Function0<R> {
        var value : Option<R> = None;

        return function() {
            return switch(value) {
                case Some(value): value;
                case _:
                    value = Some(func());
                    value.get();
            };
        };
    }
}
