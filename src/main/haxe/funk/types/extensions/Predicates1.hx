package funk.types.extensions;

import funk.Funk;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Predicate1;

class Predicates1 {

	public static function and<T1>(p0 : Predicate1<T1>, p1 : Predicate1<T1>) : Predicate1<T1> {
		return function(value0) {
			return p0(value0) && p1(value0);
		};
	}

	public static function not<T1>(p : Predicate1<T1>) : Predicate1<T1> {
		return function(value0) {
			return !p(value0);
		};
	}

	public static function or<T1>(p0 : Predicate1<T1>, p1 : Predicate1<T1>) : Predicate1<T1> {
		return function(value0) {
			return p0(value0) || p1(value0);
		};
	}

	public static function ifElse<T1, R>(	p : Predicate1<T1>,
											ifFunc : Function0<R>,
											elseFunc : Function0<R>
											) : Function1<T1, R> {
		return function(value0) {
			return if (p(value0)) {
				ifFunc();
			} else {
				elseFunc();
			}
		};
	}
}
