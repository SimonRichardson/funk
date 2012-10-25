package funk;

import funk.option.Option;

enum Lazy<T> {
	lazy(func : Void -> T);
	lazyWithArguments(func : Array<Dynamic> -> T, args : Array<Dynamic>);
}

private enum Evaluated<T> {
	evaluated(lazy : Lazy<T>, value : T);
}

class Lazys {

	private static var instances = [];

	public static function call<T>(lax : Lazy<T>) : T {
		return switch(lax) {
			case lazy(func): 
				func();
			case lazyWithArguments(func, args):
				Reflect.callMethod(null, func, args);
		};
	}

	public static function get<T>(lax : Lazy<T>) : T {
		var evaluation = getEvaluation(lax);
		return switch(evaluation) {
			case Some(value):
				value;
			case None:
				var result = Lazys.call(lax);
				instances.push(evaluated(lax, result));
				result;
		}
	}

	private static function getEvaluation<T>(lax : Lazy<T>) : Option<T> {
		// Find out if it's been evaluated
		for(i in 0...instances.length) {
			var e : Evaluated<Dynamic> = cast instances[i];
			switch(e) {
				case evaluated(l, value):
					if(Type.enumEq(cast lax, cast l)) {
						return Some(value);
					}
			}
		}

		return None;
	}
}