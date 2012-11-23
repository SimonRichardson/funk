package funk.types.extensions;

import funk.Funk;
import funk.types.Function0;
import funk.types.Function4;
import funk.types.Predicate4;

class Predicates4 {

	public static function and<T1, T2, T3, T4>(	p0 : Predicate4<T1, T2, T3, T4>,
												p1 : Predicate4<T1, T2, T3, T4>
												) : Predicate4<T1, T2, T3, T4> {
		return function(value0, value1, value2, value3) {
			return p0(value0, value1, value2, value3) && p1(value0, value1, value2, value3);
		};
	}

	public static function not<T1, T2, T3, T4>(p : Predicate4<T1, T2, T3, T4>) : Predicate4<T1, T2, T3, T4> {
		return function(value0, value1, value2, value3) {
			return !p(value0, value1, value2, value3);
		};
	}

	public static function or<T1, T2, T3, T4>(	p0 : Predicate4<T1, T2, T3, T4>,
												p1 : Predicate4<T1, T2, T3, T4>
												) : Predicate4<T1, T2, T3, T4> {
		return function(value0, value1, value2, value3) {
			return p0(value0, value1, value2, value3) || p1(value0, value1, value2, value3);
		};
	}

	public static function ifElse<T1, T2, T3, T4, R>(	p : Predicate4<T1, T2, T3, T4>,
														ifFunc : Function0<R>,
														elseFunc : Function0<R>
														) : Function4<T1, T2, T3, T4, R> {
		return function(value0, value1, value2, value3) {
			return if (p(value0, value1, value2, value3)) {
				ifFunc();
			} else {
				elseFunc();
			}
		};
	}
}
