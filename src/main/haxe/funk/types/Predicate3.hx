package funk.types;

using funk.types.Function0;
using funk.types.Function3;
using funk.types.Predicate3;

typedef Predicate3<T1, T2, T3> = Function3<T1, T2, T3, Bool>;

class Predicate3Types {

    public static function and<T1, T2, T3>( p0 : Predicate3<T1, T2, T3>,
                                            p1 : Predicate3<T1, T2, T3>
                                            ) : Predicate3<T1, T2, T3> {
        return function(value0, value1, value2) {
            return p0(value0, value1, value2) && p1(value0, value1, value2);
        };
    }

    public static function not<T1, T2, T3>(p : Predicate3<T1, T2, T3>) : Predicate3<T1, T2, T3> {
        return function(value0, value1, value2) {
            return !p(value0, value1, value2);
        };
    }

    public static function or<T1, T2, T3>(  p0 : Predicate3<T1, T2, T3>,
                                            p1 : Predicate3<T1, T2, T3>
                                            ) : Predicate3<T1, T2, T3> {
        return function(value0, value1, value2) {
            return p0(value0, value1, value2) || p1(value0, value1, value2);
        };
    }

    public static function ifElse<T1, T2, T3, R>(   p : Predicate3<T1, T2, T3>,
                                                    ifFunc : Function0<R>,
                                                    elseFunc : Function0<R>
                                                    ) : Function3<T1, T2, T3, R> {
        return function(value0, value1, value2) {
            return if (p(value0, value1, value2)) {
                ifFunc();
            } else {
                elseFunc();
            }
        };
    }
}
