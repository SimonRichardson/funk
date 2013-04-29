package funk.types;

using funk.types.Function1;
using funk.types.Option;

typedef Function0<R> = Void -> R;
typedef Dispatcher0<R> = {
    function dispatch() : R;
}
typedef Executioner0<R> = {
    function execute() : R;
}

class Function0Types {

    public static function _0<T1>(func : Function0<T1>) : Function0<T1> return function() return func();

    public static function map<T1, R>(func : Function0<T1>, mapper : Function1<T1, R>) : Function0<R> {
        return function() return mapper(func());
    }

    public static function flatMap<T1, R>(func : Function0<T1>, mapper : Function1<T1, Function0<R>>) : Function0<R> {
        return function() return mapper(func())();
    }

    public static function promote<T1, R>(func : Function0<R>) : Function1<T1, R> return function(x) return func();

    public static function lazy<R>(func : Function0<R>) : Function0<R> {
        var value : R = null;
        return function() return (value == null) ? value = func() : value;
    }

    public static function effectOf<R>(func : Function0<R>) : Function0<Void> return function() func();

    public static function swallowWith<R>(func : Function0<R>, res : R) : Function0<R> {
        return function() return try func() catch (e : Dynamic) res; 
    }
}

