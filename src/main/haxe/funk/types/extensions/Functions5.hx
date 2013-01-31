package funk.types.extensions;

import funk.Funk;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Function5;
import funk.types.Tuple5;
import funk.types.Option;

using funk.types.extensions.Options;
using funk.types.extensions.Tuples5;

private typedef Curry5<T1, T2, T3, T4, T5, R> = Function1<T1, Function1<T2, Function1<T3, Function1<T4, Function1<T5, R>>>>>;

class Functions5 {

	public static function _1<T1, T2, T3, T4, T5, R>(	func : Function5<T1, T2, T3, T4, T5, R>,
														value1 : T1
														) : Function4<T2, T3, T4, T5, R> {
		return function(value2 : T2, value3 : T3, value4 : T4, value5 : T5) {
			return func(value1, value2, value3, value4, value5);
		};
	}

	public static function _2<T1, T2, T3, T4, T5, R>(	func : Function5<T1, T2, T3, T4, T5, R>,
														value2 : T2
														) : Function4<T1, T3, T4, T5, R> {
		return function(value1 : T1, value3 : T3, value4 : T4, value5 : T5) {
			return func(value1, value2, value3, value4, value5);
		};
	}

	public static function _3<T1, T2, T3, T4, T5, R>(	func : Function5<T1, T2, T3, T4, T5, R>,
														value3 : T3
														) : Function4<T1, T2, T4, T5, R> {
		return function(value1 : T1, value2 : T2, value4 : T4, value5 : T5) {
			return func(value1, value2, value3, value4, value5);
		};
	}

	public static function _4<T1, T2, T3, T4, T5, R>(	func : Function5<T1, T2, T3, T4, T5, R>,
														value4 : T4
														) : Function4<T1, T2, T3, T5, R> {
		return function(value1 : T1, value2 : T2, value3 : T3, value5 : T5) {
			return func(value1, value2, value3, value4, value5);
		};
	}

	public static function _5<T1, T2, T3, T4, T5, R>(	func : Function5<T1, T2, T3, T4, T5, R>,
														value5 : T5
														) : Function4<T1, T2, T3, T4, R> {
		return function(value1 : T1, value2 : T2, value3 : T3, value4 : T4) {
			return func(value1, value2, value3, value4, value5);
		};
	}

	public static function compose<T1, T2, T3, T4, T5, C, R>(	from : Function1<C, R>,
																to : Function5<T1, T2, T3, T4, T5, C>
																) : Function5<T1, T2, T3, T4, T5, R> {
		return function(value0 : T1, value1 : T2, value2 : T3, value3 : T4, value4 : T5) {
			return from(to(value0, value1, value2, value3, value4));
		};
	}

	public static function map<T1, T2, T3, T4, T5, M, R>(	func : Function5<T1, T2, T3, T4, T5, M>,
															mapper : Function1<M, R>
															) : Function5<T1, T2, T3, T4, T5, R> {
		return function(value0 : T1, value1 : T2, value2 : T3, value3 : T4, value4 : T5) {
			return mapper(func(value0, value1, value2, value3, value4));
		};
	}

	public static function curry<T1, T2, T3, T4, T5, R>(	func : Function5<T1, T2, T3, T4, T5, R>
															) : Curry5<T1, T2, T3, T4, T5, R> {
		return function(value0 : T1) {
			return function(value1 : T2) {
				return function(value2 : T3) {
					return function(value3 : T4) {
						return function(value4 : T5) {
							return func(value0, value1, value2, value3, value4);
						};
					};
				};
			};
		};
	}

	public static function uncurry<T1, T2, T3, T4, T5, R>(	func : Curry5<T1, T2, T3, T4, T5, R>
															) : Function5<T1, T2, T3, T4, T5, R> {
		return function(value0 : T1, value1 : T2, value2 : T3, value3 : T4, value4 : T5) {
			return func(value0)(value1)(value2)(value3)(value4);
		};
	}

	public static function untuple<T1, T2, T3, T4, T5, R>(	func : Function5<T1, T2, T3, T4, T5, R>
															) : Function1<Tuple5<T1, T2, T3, T4, T5>, R> {
		return function(tuple) {
			return func(tuple._1(), tuple._2(), tuple._3(), tuple._4(), tuple._5());
		};
	}

	public static function tuple<T1, T2, T3, T4, T5, R>(	func : Function1<Tuple5<T1, T2, T3, T4, T5>, R>
															) : Function5<T1, T2, T3, T4, T5, R> {
		return function(value0, value1, value2, value3, value4) {
			return func(tuple5(value0, value1, value2, value3, value4));
		};
	}

	public static function wait<T1, T2, T3, T4, T5>(	func : Function5<T1, T2, T3, T4, T5, Void>, 
														?async : Async5<T1, T2, T3, T4, T5> = null
														) : Async5<T1, T2, T3, T4, T5> {
		return new Async5(func).add(async.toOption());
	}
}
