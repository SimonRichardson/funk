package funk.collections.extensions;

import funk.types.Function1;
import funk.types.Function2;
import funk.types.Function3;

class Collections {

	public static function map<T, R>(iterable : Iterable<T>, func : Function1<T, R>) : Iterable<R> {
		var mapped = [];
		for(item in iterable.iterator()) {
			mapped.push(func(item));
		}
		return mapped;
	}

	public static function foldLeft<T>(iterable : Iterable<T>, value : T, func : Function2<T, T, T>) : T {
		for(item in iterable.iterator()) {
			value = func(value, item);
		}
		return value;
	}

	public static function foldLeftWithIndex<T>(iterable : Iterable<T>, value : T, func : Function3<T, T, Int, T>) : T {
		var index = 0;
		for(item in iterable.iterator()) {
			value = func(value, item, index++);
		}
		return value;
	}

	public static function toArray<T>(iterator : Iterator<T>) : Array<T> {
		var stack = [];
		
		while(iterator.hasNext()) {
			var item : T = iterator.next();
			stack.push(item);
		}

		return stack;
	}
}