package funk.types.extensions;

import funk.Funk;
import funk.types.Function0;
import funk.types.Function3;
import funk.types.Predicate3;

class Predicates3 {

	public static function and<T1, T2, T3>(	p0 : Predicate3<T1, T2, T3>,
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

	public static function or<T1, T2, T3>(	p0 : Predicate3<T1, T2, T3>,
											p1 : Predicate3<T1, T2, T3>
											) : Predicate3<T1, T2, T3> {
		return function(value0, value1, value2) {
			return p0(value0, value1, value2) || p1(value0, value1, value2);
		};
	}

	public static function ifElse<T1, T2, T3, R>(	p : Predicate3<T1, T2, T3>,
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
