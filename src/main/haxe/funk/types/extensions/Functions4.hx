package funk.types.extensions;

import funk.Funk;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Function4;
import funk.types.Tuple4;

using funk.types.extensions.Tuples4;

private typedef Curry4<T1, T2, T3, T4, R> = Function1<T1, Function1<T2, Function1<T3, Function1<T4, R>>>>;

class Functions4 {

	public static function _1<T1, T2, T3, T4, R>(	func : Function4<T1, T2, T3, T4, R>,
													value1 : T1
													) : Function3<T2, T3, T4, R> {
		return function(value2 : T2, value3 : T3, value4 : T4) {
			return func(value1, value2, value3, value4);
		};
	}

	public static function _2<T1, T2, T3, T4, R>(	func : Function4<T1, T2, T3, T4, R>,
													value2 : T2
													) : Function3<T1, T3, T4, R> {
		return function(value1 : T1, value3 : T3, value4 : T4) {
			return func(value1, value2, value3, value4);
		};
	}

	public static function _3<T1, T2, T3, T4, R>(	func : Function4<T1, T2, T3, T4, R>,
													value3 : T3
													) : Function3<T1, T2, T4, R> {
		return function(value1 : T1, value2 : T2, value4 : T4) {
			return func(value1, value2, value3, value4);
		};
	}

	public static function _4<T1, T2, T3, T4, R>(	func : Function4<T1, T2, T3, T4, R>,
													value4 : T4
													) : Function3<T1, T2, T3, R> {
		return function(value1 : T1, value2 : T2, value3 : T3) {
			return func(value1, value2, value3, value4);
		};
	}

	public static function compose<T1, T2, T3, T4, C, R>(	from : Function1<C, R>,
															to : Function4<T1, T2, T3, T4, C>
															) : Function4<T1, T2, T3, T4, R> {
		return function(value0 : T1, value1 : T2, value2 : T3, value3 : T4) {
			return from(to(value0, value1, value2, value3));
		};
	}

	public static function map<T1, T2, T3, T4, M, R>(	func : Function4<T1, T2, T3, T4, M>,
														mapper : Function1<M, R>
														) : Function4<T1, T2, T3, T4, R> {
		return function(value0 : T1, value1 : T2, value2 : T3, value3 : T4) {
			return mapper(func(value0, value1, value2, value3));
		};
	}

	public static function curry<T1, T2, T3, T4, R>(func : Function4<T1, T2, T3, T4, R>) : Curry4<T1, T2, T3, T4, R> {
		return function(value0 : T1) {
			return function(value1 : T2) {
				return function(value2 : T3) {
					return function(value3 : T4) {
						return func(value0, value1, value2, value3);
					};
				};
			};
		};
	}

	public static function uncurry<T1, T2, T3, T4, R>(func : Curry4<T1, T2, T3, T4, R>) : Function4<T1, T2, T3, T4, R> {
		return function(value0 : T1, value1 : T2, value2 : T3, value3 : T4) {
			return func(value0)(value1)(value2)(value3);
		};
	}

	public static function untuple<T1, T2, T3, T4, R>(	func : Function4<T1, T2, T3, T4, R>
														) : Function1<Tuple4<T1, T2, T3, T4>, R> {
		return function(tuple) {
			return func(tuple._1(), tuple._2(), tuple._3(), tuple._4());
		};
	}

	public static function tuple<T1, T2, T3, T4, R>(	func : Function1<Tuple4<T1, T2, T3, T4>, R>
														) : Function4<T1, T2, T3, T4, R> {
		return function(value0, value1, value2, value3) {
			return func(tuple4(value0, value1, value2, value3));
		};
	}
}
