package funk.collections.extensions;

import funk.types.Function1;
import funk.types.Function2;
import funk.types.Function3;
import funk.types.Predicate1;
import funk.types.Predicate2;

class Collections {

	public static function contains<T>(iterable : Iterable<T>, value : T, ?func : Predicate2<T, T>) : Bool {
		var eq : Predicate2<T, T> = function(a, b) : Bool {
			return null != func ? func(a, b) : a == b;
		};

		for(item in iterable.iterator()) {
			if (eq(item, value)) {
				return true;
			}
		}

		return false;
	}

	public static function count<T>(iterable : Iterable<T>, func : Predicate1<T>) : Int {
		var counter = 0;
		for(item in iterable.iterator()) {
			if (func(item)) {
				counter++;
			}
		}
		return counter;
	}

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
