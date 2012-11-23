package funk.types.extensions;

import funk.Funk;
import funk.types.Function0;
import funk.types.Predicate2;

class Predicates2 {

	public static function and<T1, T2>(p0 : Predicate2<T1, T2>, p1 : Predicate2<T1, T2>) : Predicate2<T1, T2> {
		return function(value0, value1) {
			return p0(value0, value1) && p1(value0, value1);
		};
	}

	public static function not<T1, T2>(p : Predicate2<T1, T2>) : Predicate2<T1, T2> {
		return function(value0, value1) {
			return !p(value0, value1);
		};
	}

	public static function or<T1, T2>(p0 : Predicate2<T1, T2>, p1 : Predicate2<T1, T2>) : Predicate2<T1, T2> {
		return function(value0, value1) {
			return p0(value0, value1) || p1(value0, value1);
		};
	}

	public static function ifElse<T1, T2, R>(	p : Predicate2<T1, T2>,
												ifFunc : Function0<R>,
												elseFunc : Function0<R>
												) : Function2<T1, T2, R> {
		return function(value0, value1) {
			return if (p(value0, value1)) {
				ifFunc();
			} else {
				elseFunc();
			}
		};
	}
}
