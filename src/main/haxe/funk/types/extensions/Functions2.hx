package funk.types.extensions;

import funk.Funk;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Function2;

class Functions2 {

	public static function _1<T1, T2, T3>(func : Function1<T1, T2, T3>, value1 : T1) : Function1<T2, T3> {
		return function(value2 : T2) {
			return func(value1, value2);
		};
	}

	public static function _2<T1, T2, T3>(func : Function1<T1, T2, T3>, value2 : T2) : Function1<T1, T3> {
		return function(value1 : T1) {
			return func(value1, value2);
		};
	}

	public static function map<T1, T2, T3, R>(	func : Function2<T1, T2, T3>,
												mapper : Function1<T3, R>
												) : Function2<T1, T2, R> {
		return function(value0 : T1, value1 : T2) {
			return mapper(func(a, b));
		};
	}

	public static function curry<T1, T2, T3>(func : Function2<T1, T2, T3>) : Function1<T1, Function1<T2, T3>> {
		return function(value0 : T1) {
			return function(value1 : T2) {
				return func(value0, value1);
			}
		};
	}

	public static function uncurry<T1, T2, T3>(func : Function1<T1, Function1<T2, T3>>) : Function2<T1, T2, T3> {
		return function(value0 : T1, value1 : T1) {
			return func(value0)(value1);
		};
	}

	public static function flip<T1, T2, T3>(func : Function2<T1, T2, T3>) : Function2<T2, T1, T3> {
		return function (value2, value1) {
			return func(value1, value2);
		}
	}
}
