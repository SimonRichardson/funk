package funk.collections.extensions;

import funk.Funk;
import funk.collections.Collection;
import funk.collections.extensions.CollectionsUtil;
import funk.types.Function1;
import funk.types.Function2;
import funk.types.Function3;
import funk.types.Option;
import funk.types.Predicate1;
import funk.types.Predicate2;
import funk.types.Tuple2;
import funk.types.extensions.Anys;
import funk.types.extensions.Iterators;

using funk.types.extensions.Iterators;

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

		if (amount > 0) {
			var iterator = collection.iterator();

			for (i in 0...amount) {
				if (!iterator.hasNext()) {
					return CollectionsUtil.toCollection([]);
				}
				iterator.next();
			}

			return CollectionsUtil.toCollection(iterator.toArray());
		} else {
			return collection;
		}
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
			stack.push(h);
		}

		return CollectionsUtil.toCollection(stack);
	}

	public static function dropWhile<T>(collection : Collection<T>, func : Predicate1<T>) : Collection<T> {
		var iterator = collection.iterator();
		for (i in iterator) {
			if (!func(i)) {
				var result = iterator.toArray();
				result.unshift(i);
				return CollectionsUtil.toCollection(result);
			}
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
		for(item in collection.iterator()) {
			mapped = mapped.concat(func(item).iterator().toArray());
		}
		return CollectionsUtil.toCollection(mapped);
	}

	public static function flatten<T>(collection : Collection<T>) : Collection<T> {
		return flatMap(collection, function(x) {
			return CollectionsUtil.toCollection(x);
		});
	}

	public static function filter<T>(collection : Collection<T>, func : Predicate1<T>) : Collection<T> {
		var stack = [];
		var clone = [];
		var allFiltered = true;

		for (i in collection.iterator()) {
			if (func(i)) {
				stack.push(i);
			} else {
				allFiltered = false;
			}
			clone.push(i);
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
				stack.push(i);
			} else {
				allFiltered = false;
			}
			clone.push(i);
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

	public static function foldLeft<T>(collection : Collection<T>, value : T, func : Function2<T, T, T>) : Option<T> {
		for(item in collection.iterator()) {
			value = func(value, item);
		}
		return Some(value);
	}

	public static function foldLeftWithIndex<T>(	collection : Collection<T>,
													value : T, func : Function3<T, T, Int, T>
													) : Option<T> {
		var index = 0;
		for(item in collection.iterator()) {
			value = func(value, item, index++);
		}
		return Some(value);
	}

	public static function foldRight<T>(collection : Collection<T>, value : T, func : Function2<T, T, T>) : Option<T> {
		for(item in collection.iterator().reverse()) {
			value = func(value, item);
		}
		return Some(value);
	}

	public static function foldRightWithIndex<T>(	collection : Collection<T>,
													value : T,
													func : Function3<T, T, Int, T>
													) : Option<T> {
		var index = 0;
		for(item in collection.iterator().reverse()) {
			value = func(value, item, index++);
		}
		return Some(value);
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

	public static function partition<T>(	collection : Collection<T>,
											func : Predicate1<T>
											) : Tuple2<Collection<T>, Collection<T>> {
		var left = [];
		var right = [];
		for (i in collection.iterator()) {
			if (func(i)) {
				left.push(i);
			} else {
				right.push(i);
			}
		}
		return tuple2(CollectionsUtil.toCollection(left), CollectionsUtil.toCollection(right));
	}

	public static function reduceLeft<T>(collection : Collection<T>, func : Function2<T, T, T>) : Option<T> {
		if (size(collection) < 1) {
			return None;
		}

		var iterator = collection.iterator();
		var value = iterator.next();
		for (i in iterator) {
			value = func(value, i);
		}
		return Some(value);
	}

	public static function reduceRight<T>(collection : Collection<T>, func : Function2<T, T, T>) : Option<T> {
		if (size(collection) < 1) {
			return None;
		}

		var iterator = collection.iterator().reverse();
		var value = iterator.next();
		for (i in iterator) {
			value = func(value, i);
		}
		return Some(value);
	}

	public static function takeLeft<T>(collection : Collection<T>, amount : Int) : Collection<T> {
		if (amount < 0) {
			Funk.error(Errors.ArgumentError('Amount must be positive'));
		} else if (amount == 0) {
			return CollectionsUtil.zero();
		} else if (amount > size(collection)) {
			return collection;
		}

		var iterator = collection.iterator();

		var stack = [];
		for (i in 0...amount) {
			stack.push(iterator.next());
		}
		return CollectionsUtil.toCollection(stack);
	}

	public static function takeRight<T>(collection : Collection<T>, amount : Int) : Collection<T> {
		if (amount < 0) {
			Funk.error(Errors.ArgumentError('Amount must be positive'));
		} else if (amount == 0) {
			return CollectionsUtil.zero();
		} else if (amount > size(collection)) {
			return collection;
		}

		var iterator = collection.iterator().reverse();

		var stack = [];
		for (i in 0...amount) {
			stack.push(iterator.next());
		}
		return reverse(CollectionsUtil.toCollection(stack));
	}

	public static function takeWhile<T>(collection : Collection<T>, func : Predicate1<T>) : Collection<T> {
		var stack = [];
		for (i in collection.iterator()) {
			if (func(i)) {
				stack.push(i);
			}
		}
		return CollectionsUtil.toCollection(stack);
	}

	public static function zip<T1, T2>(	collection : Collection<T1>,
										other : Collection<T2>
										) : Collection<Tuple2<T1, T2>> {
		var amount = Std.int(Math.min(size(collection), size(other)));

		if (amount <= 0) {
			return CollectionsUtil.zero();
		}

		var iterator0 = collection.iterator();
		var iterator1 = other.iterator();

		var stack = [];
		for (i in 0...amount) {
			stack.push(tuple2(iterator0.next(), iterator1.next()));
		}

		return CollectionsUtil.toCollection(stack);
	}

	public static function append<T>(collection : Collection<T>, item : T) : Collection<T> {
		var stack = toArray(collection);
		stack.push(item);
		return CollectionsUtil.toCollection(stack);
	}

	public static function appendAll<T>(collection : Collection<T>, items : Collection<T>) : Collection<T> {
		var stack = toArray(collection);
		stack = stack.concat(toArray(items));
		return CollectionsUtil.toCollection(stack);
	}

	public static function appendIterator<T>(collection : Collection<T>, iterator : Iterator<T>) : Collection<T> {
		return appendAll(collection, iterator.toCollection());
	}

	public static function appendIterable<T>(collection : Collection<T>, iterable : Iterable<T>) : Collection<T> {
		return appendIterator(collection, iterable.iterator());
	}

	public static function prepend<T>(collection : Collection<T>, item : T) : Collection<T> {
		var stack = toArray(collection);
		stack.unshift(item);
		return CollectionsUtil.toCollection(stack);
	}

	public static function prependAll<T>(collection : Collection<T>, items : Collection<T>) : Collection<T> {
		var stack = toArray(collection);
		stack = toArray(reverse(items)).concat(stack);
		return CollectionsUtil.toCollection(stack);
	}

	public static function prependIterator<T>(collection : Collection<T>, iterator : Iterator<T>) : Collection<T> {
		return prependAll(collection, iterator.toCollection());
	}

	public static function prependIterable<T>(list : Collection<T>, iterable : Iterable<T>) : Collection<T> {
		return prependIterator(list, iterable.iterator());
	}

	public static function head<T>(collection : Collection<T>) : T {
		return if (collection.size() < 1) {
			null;
		} else {
			collection.iterator().next();
		}
	}

	public static function headOption<T>(collection : Collection<T>) : Option<T> {
		return if (collection.size() < 1) {
			None;
		} else {
			Some(collection.iterator().next());
		}
	}

	public static function tail<T>(collection : Collection<T>) : Collection<T> {
		return if (collection.size() < 1) {
			CollectionsUtil.zero();
		} else {
			var iterator = collection.iterator();
			iterator.next();
			Iterators.toCollection(iterator);
		}
	}

	public static function tailOption<T>(collection : Collection<T>) : Option<Collection<T>> {
		var t = tail(collection);
		return if (t.size() < 1) {
			None;
		} else {
			Some(t);
		}
	}

	public static function reverse<T>(collection : Collection<T>) : Collection<T> {
		return Iterators.toCollection(collection.iterator().reverse());
	}

	public static function size<T>(collection : Collection<T>) : Int {
		return collection.size();
	}

	public static function indices<T>(collection : Collection<T>) : Collection<Int> {
		var stack = [];
		var index = 0;
		for (i in collection.iterator()) {
			stack.push(index++);
		}
		return CollectionsUtil.toCollection(stack);
	}

	public static function init<T>(collection : Collection<T>) : Collection<T> {
		return dropRight(collection, 1);
	}

	public static function last<T>(collection : Collection<T>) : Option<T> {
		var value = None;
		for (i in collection.iterator()) {
			value = Some(i);
		}
		return value;
	}

	public static function zipWithIndex<T>(collection : Collection<T>) : Collection<Tuple2<T, Int>> {
		var amount = size(collection);

		var stack = [];
		var index = 0;
		for (i in collection.iterator()) {
			stack.push(tuple2(i, index++));
		}
		return CollectionsUtil.toCollection(stack);
	}

	public static function isEmpty<T>(collection : Collection<T>) : Bool {
		return size(collection) < 1;
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
		return if (size(collection) < 1) {
			'Collection';
		} else {
			var mapped : Collection<String> = map(collection, function(value) {
				return Anys.toString(value, func);
			});
			'Collection(' + foldLeftWithIndex(mapped, '', function(a, b, index) {
				return (index < 1) ? b : a + ', ' + b;
			}) + ')';
		}
	}
}

