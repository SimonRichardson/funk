package funk.types.extensions;

import funk.Funk;
import funk.types.Function0;
import funk.types.Predicate0;

class Predicates0 {

	public static function and(p0 : Predicate0, p1 : Predicate0) : Predicate0 {
		return function() {
			return p0() && p1();
		};
	}

	public static function not(p : Predicate0) : Predicate0 {
		return function() {
			return !p();
		};
	}

	public static function or(p0 : Predicate0, p1 : Predicate0) : Predicate0 {
		return function() {
			return p0() || p1();
		};
	}

	public static function ifElse<R>(	p : Predicate0,
										ifFunc : Function0<R>,
										elseFunc : Function0<R>
										) : Function0<R> {
		return function() {
			return if (p()) {
				ifFunc();
			} else {
				elseFunc();
			}
		};
	}
}
