package funk.types.extensions;

import funk.Funk;
import funk.types.Function0;
import funk.types.Function1;
import haxe.ds.Option;

using funk.types.extensions.Options;
using funk.types.extensions.Tuples1;

class Functions1 {

	public static function _1<T1, R>(func : Function1<T1, R>, value1 : T1) : Function0<R> {
		return function() {
			return func(value1);
		};
	}

	public static function compose<T1, T2, R>(from : Function1<T2, R>, to : Function1<T1, T2>) : Function1<T1, R> {
		return function(value0 : T1) {
			return from(to(value0));
		};
	}

	public static function map<T1, T2, R>(func : Function1<T1, T2>, mapper : Function1<T2, R>) : Function1<T1, R> {
		return function(value0 : T1) {
			return mapper(func(value0));
		};
	}

	public static function curry<T1, T2>(func : Function1<T1, T2>) : Function1<T1, T2> {
		return func;
	}

	public static function uncurry<T1, R>(func : Function1<T1, Function0<R>>) : Function1<T1, R> {
		return function(value0 : T1) : R {
			return func(value0)();
		};
	}

	public static function untuple<T1, R>(func : Function1<T1, R>) : Function1<Tuple1<T1>, R> {
		return function(tuple) {
			return func(tuple._1());
		};
	}

	public static function tuple<T1, R>(func : Function1<Tuple1<T1>, R>) : Function1<T1, R> {
		return function(value0) {
			return func(tuple1(value0));
		};
	}
}
