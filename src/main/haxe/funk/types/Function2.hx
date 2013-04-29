package funk.types;

import funk.types.Any;
import funk.types.Wildcard;

using funk.types.Function0;
using funk.types.Function1;
using funk.types.Option;
using funk.types.Tuple2;

typedef Function2<T1, T2, R> = T1 -> T2 -> R;

private typedef Curry2<T1, T2, R> = Function1<T1, Function1<T2, R>>;

class Function2Types {

    public static function _1<T1, T2, R>(func : Function2<T1, T2, R>, value1 : T1) : Function1<T2, R> {
        return function(value2 : T2) return func(value1, value2);
    }

    public static function _2<T1, T2, R>(func : Function2<T1, T2, R>, value2 : T2) : Function1<T1, R> {
        return function(value1 : T1) return func(value1, value2);
    }

    public static function flip<T1, T2, R>(func : Function2<T1, T2, R>) : Function2<T2, T1, R> {
        return function(value2, value1) return func(value1, value2);
    }

    public static function compose<T1, T2, C, R>(   from : Function1<C, R>,
                                                    to : Function2<T1, T2, C>
                                                    ) : Function2<T1, T2, R> {
        return function(value0 : T1, value1 : T2) return from(to(value0, value1));
    }

    public static function map<T1, T2, M, R>(   func : Function2<T1, T2, M>,
                                                mapper : Function1<M, R>
                                                ) : Function2<T1, T2, R> {
        return function(value0 : T1, value1 : T2) return mapper(func(value0, value1));
    }

    public static function carries<T1, T2, R>(  func : Function2<T1, T2, R>,
                                                value0 : AnyRef,
                                                value1 : AnyRef
                                                ) : AnyRef {
        var wildcard0 = AnyTypes.isInstanceOf(value0, WildcardType);
        var wildcard1 = AnyTypes.isInstanceOf(value1, WildcardType);

        if(wildcard0 && wildcard1) return curry(func);
        else if(wildcard0 && !wildcard1) return function(value0) return func(value0, value1);
        else if(!wildcard0 && wildcard1) return function(value1) return func(value0, value1);
        else return func(value0, value1);
    }

    public static function curry<T1, T2, R>(func : Function2<T1, T2, R>) : Curry2<T1, T2, R> {
        return function(value0 : T1) {
            return function(value1 : T2) return func(value0, value1);
        };
    }

    public static function uncurry<T1, T2, R>(func : Curry2<T1, T2, R>) : Function2<T1, T2, R> {
        return function(value0 : T1, value1 : T2) return func(value0)(value1);
    }

    public static function untuple<T1, T2, R>(func : Function2<T1, T2, R>) : Function1<Tuple2<T1, T2>, R> {
        return function(tuple : Tuple2<T1, T2>) return func(tuple._1(), tuple._2());
    }

    public static function tuple<T1, T2, R>(func : Function1<Tuple2<T1, T2>, R>) : Function2<T1, T2, R> {
        return function(value0, value1) return func(tuple2(value0, value1));
    }

    public static function lazy<T1, T2, R>( func : Function2<T1, T2, R>, 
                                            value0 : T1, 
                                            value1 : T2
                                            ) : Function0<R> {
        var value : R = null;
        return function() return (value == null) ? value = func(value0, value1) : value;
    }
}
