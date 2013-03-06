package funk.types;

using funk.types.Function1;
using funk.types.Option;

typedef Function0Type<R> = Void -> R;

abstract Function0<R>(Function0Type<R>) from Function0Type<R> to Function0Type<R> {

    inline function new(function : Function0Type<R>) {
        this = function;
    }
}

class Function0Types {

    public static function _0<T1>(func : Function0<T1>) : Function0<T1> {
        return function() {
            return func();
        };
    }

    public static function map<T1, R>(func : Function0<T1>, mapper : Function1<T1, R>) : Function0<R> {
        return function() {
            return mapper(func());
        };
    }

    public static function flatMap<T1, R>(func : Function0<T1>, mapper : Function1<T1, Function0<R>>) : Function0<R> {
        return function() {
            return mapper(func())();
        };
    }

    public static function promote<T1, R>(func : Function0<R>) : Function1<T1, R> {
        return function(x) {
            return func();
        };
    }
}

