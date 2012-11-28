package funk.collections.extensions;

import funk.collections.extensions.IteratorsUtil;
import funk.types.Function1;
import funk.types.Function2;
import funk.types.Function3;
import funk.types.Predicate1;
import funk.types.Predicate2;

using funk.collections.extensions.IteratorsUtil;

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

	public static function dropLeft<T>(iterable : Iterable<T>, amount : Int) : Iterable<T> {
		if (amount < 0) {
			Funk.error(Errors.ArgumentError('Amount must be positive'));
		}

		var iterator = iterable.iterator();

		var stack = [];
		for (i in 0...amount) {
			if (!iterator.hasNext()) {
				return [];
			}
			stack.push(iterator.next());
		}

		return stack;
	}

	public static function map<T, R>(iterable : Iterable<T>, func : Function1<T, R>) : Iterable<R> {
		var mapped = [];
		for(item in iterable.iterator()) {
			mapped.push(func(item));
		}
		return mapped;
	}

	public static function flatMap<T, R>(iterable : Iterable<T>, func : Function1<T, Iterable<R>>) : Iterable<R> {
		var mapped = [];
		for(item in iterable.iterator()) {
			mapped = mapped.concat(func(item).iterator().toArray());
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

	public static function foldRight<T>(iterable : Iterable<T>, value : T, func : Function2<T, T, T>) : T {
		for(item in iterable.iterator().reverse()) {
			value = func(value, item);
		}
		return value;
	}

	public static function foldRightWithIndex<T>(	iterable : Iterable<T>,
													value : T,
													func : Function3<T, T, Int, T>
													) : T {
		var index = 0;
		for(item in iterable.iterator().reverse()) {
			value = func(value, item, index++);
		}
		return value;
	}

	public static function toString<T>(iterable : Iterable<T>, ?func : Function1<T, String>) : String {
		var mapped : Iterable<String> = map(iterable, function(value) {
			return Anys.toString(value, func);
		});

		return 'Collection(' + foldLeftWithIndex(mapped, '', function(a, b, index) {
			return (index < 1) ? b : a + ', ' + b;
		}) + ')';
	}
}

