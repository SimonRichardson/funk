package funk;

import funk.Funk;
import funk.option.Option;

using funk.option.Option;

enum Lazy<T> {
	lazy(func : Function0<T>);
}

class Lazys {

	public static function call<T>(lax : Lazy<T>) : T {
		return switch(lax) {
			case lazy(func):
				func();
		};
	}

	public static function get<T>(lax : Lazy<T>) : Function0<T> {
		var value : Option<T> = None;

		return function() {
			return switch(lax) {
				case lazy(func):
					switch(value) {
						case Some(v):
							v;
						case None:
							value = Some(func());
							value.get();
					}
			}
		};
	}

}
