package funk.types.extensions;

import funk.Funk;
import funk.types.Function0;
import funk.types.Function1;

class Functions1 {

	public static function _1<T1, T2>(func : Function1<T1, T2>, value1 : T1) : Function0<T2> {
		return function() {
			return func(value1);
		};
	}

	public static function map<T1, T2, R>(func : Function1<T1, T2>, mapper : Function1<T2, R>) : Function1<T1, R> {
		return function(value0 : T1) {
			return mapper(func(a));
		};
	}

	public static function curry<T1, T2>(func : Function1<T1, T2>) : Function1<T1, T2> {
		return func;
	}

	public static function uncurry<T1, T2>(func : Function1<T1, T2>) : Function1<T1, T2> {
		return function(value0 : T1) {
			return func(value0)();
		};
	}

	public static function compose<T1, T2, T3>(from : Function1<T2, T3>, to : Function1<T1, T2>) : Function1<T1, T3> {
		return function(value0 : T1) {
			return from(to(a));
		};
	}
}
