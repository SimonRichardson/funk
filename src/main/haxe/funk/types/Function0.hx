package funk.types;

using funk.types.Function1;
using funk.types.Option;

typedef Function0<R> = Void -> R;

class Function0Types {

    public static function _0<T1>(func : Function0<T1>) : Function0<T1> return function() return func();

    public static function map<T1, R>(func : Function0<T1>, mapper : Function1<T1, R>) : Function0<R> {
        return function() return mapper(func());
    }

    public static function flatMap<T1, R>(func : Function0<T1>, mapper : Function1<T1, Function0<R>>) : Function0<R> {
        return function() return mapper(func())();
    }

    public static function promote<T1, R>(func : Function0<R>) : Function1<T1, R> return function(x) return func();
}

