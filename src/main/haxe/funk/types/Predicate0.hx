package funk.types;

using funk.types.Function0;
using funk.types.Predicate0;

typedef Predicate0 = Function0<Bool>;

class Predicate0Types {

    public static function and(p0 : Predicate0, p1 : Predicate0) : Predicate0 return function() return p0() && p1();

    public static function not(p : Predicate0) : Predicate0 return function() return !p();

    public static function or(p0 : Predicate0, p1 : Predicate0) : Predicate0 return function() return p0() || p1();

    public static function ifElse<R>(   p : Predicate0,
                                        ifFunc : Function0<R>,
                                        elseFunc : Function0<R>
                                        ) : Function0<R> {
        return function() return p() ? ifFunc() : elseFunc();
    }
}
