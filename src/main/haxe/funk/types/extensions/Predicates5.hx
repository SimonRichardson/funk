package funk.types.extensions;

import funk.Funk;
import funk.types.Function0;
import funk.types.Function5;
import funk.types.Predicate5;

class Predicates5 {

	public static function and<T1, T2, T3, T4, T5>(	p0 : Predicate5<T1, T2, T3, T4, T5>,
													p1 : Predicate5<T1, T2, T3, T4, T5>
													) : Predicate5<T1, T2, T3, T4, T5> {
		return function(value0, value1, value2, value3, value4) {
			return p0(value0, value1, value2, value3, value4) && p1(value0, value1, value2, value3, value4);
		};
	}

	public static function not<T1, T2, T3, T4, T5>(	p : Predicate5<T1, T2, T3, T4, T5>
													) : Predicate5<T1, T2, T3, T4, T5> {
		return function(value0, value1, value2, value3, value4) {
			return !p(value0, value1, value2, value3, value4);
		};
	}

	public static function or<T1, T2, T3, T4, T5>(	p0 : Predicate5<T1, T2, T3, T4, T5>,
													p1 : Predicate5<T1, T2, T3, T4, T5>
													) : Predicate5<T1, T2, T3, T4, T5> {
		return function(value0, value1, value2, value3, value4) {
			return p0(value0, value1, value2, value3, value4) || p1(value0, value1, value2, value3, value4);
		};
	}

	public static function ifElse<T1, T2, T3, T4, T5, R>(	p : Predicate5<T1, T2, T3, T4, T5>,
															ifFunc : Function0<R>,
															elseFunc : Function0<R>
															) : Function5<T1, T2, T3, T4, T5, R> {
		return function(value0, value1, value2, value3, value4) {
			return if (p(value0, value1, value2, value3, value4)) {
				ifFunc();
			} else {
				elseFunc();
			}
		};
	}
}
