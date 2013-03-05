package funk.types.extensions;

import funk.Funk;
import funk.types.Lazy;

using funk.types.Option;

class Lazys {

	public static function lazy<R>(func : Lazy<R>) : Function0<R> {
		var value : Option<R> = None;

		return function() {	
			return switch(value) {
				case Some(value): value;
				case None:
					value = Some(func());
					value.get();
			};
		};
	}
}


	