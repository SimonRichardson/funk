package funk.types.extensions;

import funk.Funk;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Function3;
import funk.types.Tuple3;

using funk.types.extensions.Tuples3;

private typedef Curry3<T1, T2, T3, R> = Function1<T1, Function1<T2, Function1<T3, R>>>;

class Functions3 {

	public static function _1<T1, T2, T3, R>(func : Function3<T1, T2, T3, R>, value1 : T1) : Function2<T2, T3, R> {
		return function(value2 : T2, value3 : T3) {
			return func(value1, value2, value3);
		};
	}

	public static function _2<T1, T2, T3, R>(func : Function3<T1, T2, T3, R>, value2 : T2) : Function2<T1, T3, R> {
		return function(value1 : T1, value3 : T3) {
			return func(value1, value2, value3);
		};
	}

	public static function _3<T1, T2, T3, R>(func : Function3<T1, T2, T3, R>, value3 : T3) : Function2<T1, T2, R> {
		return function(value1 : T1, value2 : T2) {
			return func(value1, value2, value3);
		};
	}

	public static function compose<T1, T2, T3, C, R>(	from : Function1<C, R>, 
														to : Function3<T1, T2, T3, C>
														) : Function3<T1, T2, T3, R> {
		return function(value0 : T1, value1 : T2, value2 : T3) {
			return from(to(value0, value1, value2));
		};
	}

	public static function map<T1, T2, T3, M, R>(	func : Function3<T1, T2, T3, M>,
													mapper : Function1<M, R>
													) : Function3<T1, T2, T3, R> {
		return function(value0 : T1, value1 : T2, value2 : T3) {
			return mapper(func(value0, value1, value2));
		};
	}

	public static function curry<T1, T2, T3, R>(func : Function3<T1, T2, T3, R>) : Curry3<T1, T2, T3, R> {
		return function(value0 : T1) {
			return function(value1 : T2) {
				return function(value2 : T3) {
					return func(value0, value1, value2);	
				};
			};
		};
	}

	public static function uncurry<T1, T2, T3, R>(func : Curry3<T1, T2, T3, R>) : Function3<T1, T2, T3, R> {
		return function(value0 : T1, value1 : T2, value2 : T3) {
			return func(value0)(value1)(value2);
		};
	}

	public static function tuple<T1, T2, T3, R>(	func : Function3<T1, T2, T3, R>
													) : Function1<Tuple3<T1, T2, T3>, R> {
		return function(tuple) {
			return func(tuple._1(), tuple._2(), tuple._3());
		};
	}

	public static function untuple<T1, T2, T3, R>(func : Function1<Tuple3<T1, T2, T3>, R>) : Function3<T1, T2, T3, R> {
		return function(value0, value1, value2) {
			return func(tuple3(value0, value1, value2));
		};
	}

	public static function equals<T1, T2, T3, R>(	func0 : Function3<T1, T2, T3, R>, 
													func1 : Function3<T1, T2, T3, R>
													) : Bool {
		return if (func0 == func1) {
			true;
		} else {
			#if js
			// This will be wrapped in a bind method.
			if (Reflect.hasField(func0, 'method') && Reflect.hasField(func1, 'method')) {
				var field0 = Reflect.field(func0, 'method');
				var field1 = Reflect.field(func1, 'method');

				// Check to see if we've got any real binding methods.
				if(field0 == field1 || field0 == func1 || field1 == func0) {
					true;
				}
			}
			#end
			false;
		}
	}
}
