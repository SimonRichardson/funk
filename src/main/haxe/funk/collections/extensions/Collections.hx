package funk.collections.extensions;

import funk.collections.Collection;
import funk.collections.extensions.IteratorsUtil;
import funk.types.extensions.Anys;
import funk.types.Function1;
import funk.types.Function2;
import funk.types.Function3;
import funk.types.Option;
import funk.types.Predicate1;
import funk.types.Predicate2;

using funk.collections.extensions.IteratorsUtil;

class Collections {

	public static function contains<T>(collection : Collection<T>, value : T, ?func : Predicate2<T, T>) : Bool {
		for(item in collection.iterator()) {
			if (Anys.equals(item, value, func)) {
				return true;
			}
		}

		return false;
	}

	public static function count<T>(collection : Collection<T>, func : Predicate1<T>) : Int {
		var counter = 0;
		for(item in collection.iterator()) {
			if (func(item)) {
				counter++;
			}
		}
		return counter;
	}

	public static function dropLeft<T>(collection : Collection<T>, amount : Int) : Collection<T> {
		if (amount < 0) {
			Funk.error(Errors.ArgumentError('Amount must be positive'));
		}

		var iterator = collection.iterator();

		var stack = [];
		for (i in 0...amount) {
			if (!collection.hasNext()) {
				return [];
			}
			stack.push(collection.next());
		}

		return CollectionsUtil.toCollection(stack);
	}

	public static function dropRight<T>(collection : Collection<T>, amount : Int) : Collection<T> {
		if (amount < 0) {
			Funk.error(Errors.ArgumentError('Amount must be positive'));
		} else if (amount == 0) {
			return collection;
		}

		amount = collection.size() - amount;
		if (amount <= 0) {
			return CollectionsUtil.toCollection([]);
		}

		var iterator = collection.iterator();

		var stack = [];
		for (i in 0...amount) {
			var h = iterator.next();
			stack.unshift(h);
		}

		return stack;
	}

	public static function dropWhile<T>(collection : Collection<T>, func : Predicate1<T>) : Collection<T> {
		var stack = [];
		for (i in collection.iterator()) {
			if (!func(i)) {
				return CollectionsUtil.toCollection(stack);
			}
			stack.push(i);
		}
		return CollectionsUtil.toCollection([]);
	}

	public static function exists<T>(collection : Collection<T>, func : Predicate1<T>) : Bool {
		for (i in collection.iterator()) {
			if (func(i)) {
				return true;
			}
		}
		return false;
	}

	public static function flatMap<T>(	collection : Collection<T>,
										func : Function1<T, Collection<T>>
										) : Collection<T> {
		var mapped = [];
		for(item in iterable.iterator()) {
			mapped = mapped.concat(func(item).iterator().toArray());
		}
		return CollectionsUtil.toCollection(mapped);
	}

	public static function flatten<T>(collection : Collection<T>) : Collection<T> {
		return flatMap(list, function(x) {
			return CollectionsUtil.toCollection(x);
		});
	}

	public static function filter<T>(collection : Collection<T>, func : Predicate1<T>) : Collection<T> {
		var stack = [];
		var clone = [];
		var allFiltered = true;

		for (i in collection.iterator()) {
			if (func(i)) {
				stack.unshift(i);
			} else {
				allFiltered = false;
			}
			clone.unshift(i);
		}

		if (allFiltered) {
			return CollectionsUtil.toCollection(clone);
		}

		return CollectionsUtil.toCollection(stack);
	}

	public static function filterNot<T>(collection : Collection<T>, func : Predicate1<T>) : Collection<T> {
		var stack = [];
		var clone = [];
		var allFiltered = true;

		for (i in collection.iterator()) {
			if (!func(i)) {
				stack.unshift(i);
			} else {
				allFiltered = false;
			}
			clone.unshift(i);
		}

		if (allFiltered) {
			return CollectionsUtil.toCollection(clone);
		}

		return CollectionsUtil.toCollection(stack);
	}

	public static function find<T>(collection : Collection<T>, func : Predicate1<T>) : Option<T> {
		for (i in collection.iterator()) {
			if (func(i)) {
				return Some(i);
			}
		}
		return None;
	}

	public static function findIndexOf<T>(collection : Collection<T>, func : Predicate1<T>) : Int {
		var index = 0;
		for (i in collection.iterator()) {
			if (func(i)) {
				return index;
			}
			index++;
		}
		return -1;
	}

	public static function foldLeft<T>(collection : Collection<T>, value : T, func : Function2<T, T, T>) : T {
		for(item in collection.iterator()) {
			value = func(value, item);
		}
		return value;
	}

	public static function foldLeftWithIndex<T>(	collection : Collection<T>,
													value : T, func : Function3<T, T, Int, T>
													) : T {
		var index = 0;
		for(item in collection.iterator()) {
			value = func(value, item, index++);
		}
		return value;
	}

	public static function foldRight<T>(collection : Collection<T>, value : T, func : Function2<T, T, T>) : T {
		for(item in collection.iterator().reverse()) {
			value = func(value, item);
		}
		return value;
	}

	public static function foldRightWithIndex<T>(	collection : Collection<T>,
													value : T,
													func : Function3<T, T, Int, T>
													) : T {
		var index = 0;
		for(item in collection.iterator().reverse()) {
			value = func(value, item, index++);
		}
		return value;
	}

	public static function forall<T>(collection : Collection<T>, func : Predicate1<T>) : Bool {
		for (i in collection.iterator()) {
			if (!func(i)) {
				return false;
			}
		}
		return true;
	}

	public static function foreach<T>(collection : Collection<T>, func : Function1<T, Void>) : Void {
		for (i in collection.iterator()) {
			func(i);
		}
	}

	public static function get<T>(collection : Collection<T>, index : Int) : Option<T> {
		if (index < 0 || index > collection.size()) {
			return None;
		}

		for (i in collection.iterator()) {
			if (index == 0) {
				return Some(i);
			}
			index--;
		}

		return None;
	}

	public static function indexOf<T>(collection : Collection<T>, value : T) : Int {
		var index = 0;
		for (i in collection.iterator()) {
			if (Anys.equals(i, value)) {
				return index;
			}
			index++;
		}
		return -1;
	}

	public static function map<T, R>(collection : Collection<T>, func : Function1<T, R>) : Collection<R> {
		var mapped = [];
		for(item in collection.iterator()) {
			mapped.push(func(item));
		}
		return CollectionsUtil.toCollection(mapped);
	}

	public static function isEmpty<T>(collection : Collection<T>) : Bool {
		return collection.size() < 1;
	}

	public static function nonEmpty<T>(collection : Collection<T> ) : Bool {
		return !isEmpty(collection);
	}

	public static function hasDefinedSize<T>(collection : Collection<T>) : Bool {
		return nonEmpty(collection);
	}

	public static function iterable<T>(collection : Collection<T>) : Iterable<T> {
		return collection;
	}

	public static function iterator<T>(collection : Collection<T>) : Iterator<T> {
		return collection.iterator();
	}

	public static function toArray<T>(collection : Collection<T>) : Array<T> {
		return collection.iterator().toArray();
	}

	public static function toString<T>(collection : Collection<T>, ?func : Function1<T, String>) : String {
		var mapped : Collection<String> = map(iterable, function(value) {
			return Anys.toString(value, func);
		});

		return 'Collection(' + foldLeftWithIndex(mapped, '', function(a, b, index) {
			return (index < 1) ? b : a + ', ' + b;
		}) + ')';
	}
}

