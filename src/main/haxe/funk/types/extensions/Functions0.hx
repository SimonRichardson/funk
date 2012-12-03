package funk.types.extensions;

import funk.Funk;
import funk.types.Function0;
import funk.types.Function1;

class Functions0 {

	public static function _0<T1>(func : Function0<T1>) : Function0<T1> {
		return function() {
			return func();
		};
	}

	public static function map<T1, R>(func : Function0<T1>, mapper : Function1<T1, R>) : Function0<R> {
		return function() {
			return mapper(func());
		};
	}

	public static function flatMap<T1, R>(func : Function0<T1>, mapper : Function1<T1, Function0<R>>) : Function0<R> {
		return function() {
			return mapper(func())();
		};
	}

	public static function promote<T1, R>(func : Function0<R>) : Function1<T1, R> {
		return function(x) {
			return func();
		}
	}

	public static function equals<T1>(func0 : Function0<T1>, func1 : Function0<T1>) : Bool {
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
