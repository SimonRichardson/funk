package funk.types.extensions;

import funk.types.Function0;
import funk.types.Lazy;
import funk.types.Option;
import funk.types.extensions.Options;

using funk.types.extensions.Options;

class Lazys {

	public static function apply<T>(lax : Lazy<T>, scope : Dynamic, ?args : Array<Dynamic>) : T {
		return switch (lax) {
			case lazy(func):
				Reflect.callMethod(scope, func, args.toOption().getOrElse(function() {
					return [];
				}));
		}
	}

	public static function call<T>(lax : Lazy<T>) : T {
		return switch (lax) {
			case lazy(func): func();
		}
	}

	public static function get<T>(lax : Lazy<T>) : Function0<T> {
		var value : Option<T> = None;

		return function() {
			return switch(lax) {
				case lazy(func):
					switch(value) {
						case Some(value): value;
						case None:
							value = Some(call(lax));
							value.get();
					}
			}
		}
	}

}
