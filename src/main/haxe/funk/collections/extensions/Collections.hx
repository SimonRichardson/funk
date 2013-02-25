package funk.collections.extensions;

import funk.Funk;
import funk.collections.Collection;
import funk.collections.extensions.CollectionsUtil;
import funk.types.Function1;
import funk.types.Function2;
import funk.types.Function3;
import haxe.ds.Option;
import funk.types.Predicate1;
import funk.types.Predicate2;
import funk.types.Tuple2;
import funk.types.extensions.Anys;
import funk.types.extensions.Iterators;
import funk.types.extensions.Options;

using funk.types.extensions.Iterators;
using funk.types.extensions.Options;

class Collections {

	inline public static function contains<T>(collection : Collection<T>, value : T, ?func : Predicate2<T, T>) : Bool {
		var result = false;
		var col = collection;
		for(item in col.iterator()) {
			if (Anys.equals(item, value, func)) {
				result = true;
				break;
			}
		}

		return result;
	}

	inline public static function count<T>(collection : Collection<T>, func : Predicate1<T>) : Int {
		var counter = 0;
		var col = collection;
		for(item in col.iterator()) {
			if (func(item)) {
				counter++;
			}
		}
		return counter;
	}

	inline public static function dropLeft<T>(collection : Collection<T>, amount : Int) : Collection<T> {
		if (amount < 0) {
			Funk.error(Errors.ArgumentError('Amount must be positive'));
		}

		var col = collection;
		return if (amount > 0) {
			var exit = false;
			var iterator = col.iterator();

			for (i in 0...amount) {
				if (!iterator.hasNext()) {
					exit = true;
					break;
				}
				iterator.next();
			}
			
			if (exit) {
				CollectionsUtil.toCollection([]);
			} else {
				CollectionsUtil.toCollection(iterator.toArray());
			}
		} else {
			col;
		}
	}

	inline public static function dropRight<T>(collection : Collection<T>, amount : Int) : Collection<T> {
		var col = collection;

		return if (amount < 0) {
			Funk.error(Errors.ArgumentError('Amount must be positive'));
		} else if (amount == 0) {
			col;
		} else {
			amount = col.size() - amount;

			if (amount <= 0) {
				CollectionsUtil.toCollection([]);
			} else {

				var iterator = col.iterator();

				var stack = [];
				for (i in 0...amount) {
					var h = iterator.next();
					stack.push(h);
				}

				CollectionsUtil.toCollection(stack);
			}
		}
	}

	inline public static function dropWhile<T>(collection : Collection<T>, func : Predicate1<T>) : Collection<T> {
		var exit = false;
		var result = [];

		var col = collection;
		var iterator = col.iterator();
		for (i in iterator) {
			if (!func(i)) {
				result = iterator.toArray();
				result.unshift(i);
				
				exit = true;
				break;
			}
		}
		return CollectionsUtil.toCollection(result);
	}

	inline public static function exists<T>(collection : Collection<T>, func : Predicate1<T>) : Bool {
		var col = collection;
		var result = false;
		for (i in col.iterator()) {
			if (func(i)) {
				result = true;
				break;
			}
		}
		return result;
	}

	inline public static function flatMap<T>(	collection : Collection<T>,
												func : Function1<T, Collection<T>>
												) : Collection<T> {
		var col = collection;
		var mapped = [];
		for(item in col.iterator()) {
			mapped = mapped.concat(func(item).iterator().toArray());
		}
		return CollectionsUtil.toCollection(mapped);
	}

	inline public static function flatten<T>(collection : Collection<T>) : Collection<T> {
		var col = collection;
		return flatMap(col, function(x) {
			return CollectionsUtil.toCollection(x);
		});
	}

	inline public static function filter<T>(collection : Collection<T>, func : Predicate1<T>) : Collection<T> {
		var stack = [];
		var clone = [];
		var allFiltered = true;
		var col = collection;

		for (i in col.iterator()) {
			if (func(i)) {
				stack.push(i);
			} else {
				allFiltered = false;
			}
			clone.push(i);
		}

		return if (allFiltered) {
			CollectionsUtil.toCollection(clone);
		} else {
			CollectionsUtil.toCollection(stack);
		}
	}

	inline public static function filterNot<T>(collection : Collection<T>, func : Predicate1<T>) : Collection<T> {
		var stack = [];
		var clone = [];
		var allFiltered = true;
		var col = collection;

		for (i in col.iterator()) {
			if (!func(i)) {
				stack.push(i);
			} else {
				allFiltered = false;
			}
			clone.push(i);
		}

		return if (allFiltered) {
			CollectionsUtil.toCollection(clone);
		} else {
			CollectionsUtil.toCollection(stack);
		}
	}

	inline public static function find<T>(collection : Collection<T>, func : Predicate1<T>) : Option<T> {
		var col = collection;
		var result = None;
		for (i in col.iterator()) {
			if (func(i)) {
				result = Some(i);
				break;
			}
		}
		return result;
	}

	inline public static function findIndexOf<T>(collection : Collection<T>, func : Predicate1<T>) : Int {
		var index = 0;
		var col = collection;
		var result = -1;
		for (i in col.iterator()) {
			if (func(i)) {
				result = index;
				break;
			}
			index++;
		}
		return result;
	}

	inline public static function foldLeft<T>(	collection : Collection<T>, 
												value : T, 
												func : Function2<T, T, T>
												) : Option<T> {
		var col = collection;
		for(item in col.iterator()) {
			value = func(value, item);
		}
		return Some(value);
	}

	inline public static function foldLeftWithIndex<T>(	collection : Collection<T>,
														value : T, func : Function3<T, T, Int, T>
														) : Option<T> {
		var index = 0;
		var col = collection;
		for(item in col.iterator()) {
			value = func(value, item, index++);
		}
		return Some(value);
	}

	inline public static function foldRight<T>(	collection : Collection<T>, 
												value : T, 
												func : Function2<T, T, T>
												) : Option<T> {
		var col = collection;
		for(item in col.iterator().reverse()) {
			value = func(value, item);
		}
		return Some(value);
	}

	inline public static function foldRightWithIndex<T>(	collection : Collection<T>,
															value : T,
															func : Function3<T, T, Int, T>
															) : Option<T> {
		var index = 0;
		var col = collection;
		for(item in col.iterator().reverse()) {
			value = func(value, item, index++);
		}
		return Some(value);
	}

	inline public static function forall<T>(collection : Collection<T>, func : Predicate1<T>) : Bool {
		var col = collection;
		var result = true;
		for (i in col.iterator()) {
			if (!func(i)) {
				result = false;
				break;
			}
		}
		return result;
	}

	inline public static function foreach<T>(collection : Collection<T>, func : Function1<T, Void>) : Void {
		for (i in collection.iterator()) {
			func(i);
		}
	}

	inline public static function get<T>(collection : Collection<T>, index : Int) : Option<T> {
		var col = collection;
		return if (index < 0 || index > col.size()) {
			None;
		} else {

			var result = None;
			for (i in col.iterator()) {
				if (index == 0) {
					result = Some(i);
					break;
				}
				index--;
			}

			result;
		}
	}

	inline public static function indexOf<T>(collection : Collection<T>, value : T) : Int {
		var index = 0;
		var col = collection;
		var result = -1;
		for (i in col.iterator()) {
			if (Anys.equals(i, value)) {
				result = index;
				break;
			}
			index++;
		}
		return result;
	}

	inline public static function map<T, R>(collection : Collection<T>, func : Function1<T, R>) : Collection<R> {
		var mapped = [];
		var col = collection;
		for(item in col.iterator()) {
			mapped.push(func(item));
		}
		return CollectionsUtil.toCollection(mapped);
	}

	inline public static function partition<T>(	collection : Collection<T>,
												func : Predicate1<T>
												) : Tuple2<Collection<T>, Collection<T>> {
		var left = [];
		var right = [];
		var col = collection;
		for (i in col.iterator()) {
			if (func(i)) {
				left.push(i);
			} else {
				right.push(i);
			}
		}
		return tuple2(CollectionsUtil.toCollection(left), CollectionsUtil.toCollection(right));
	}

	inline public static function reduceLeft<T>(collection : Collection<T>, func : Function2<T, T, T>) : Option<T> {
		var col = collection;
		return if (size(col) < 1) {
			None;
		} else {

			var iterator = col.iterator();
			var value = iterator.next();
			for (i in iterator) {
				value = func(value, i);
			}

			Some(value);
		}
	}

	inline public static function reduceRight<T>(collection : Collection<T>, func : Function2<T, T, T>) : Option<T> {
		var col = collection;
		return if (size(col) < 1) {
			None;
		} else {

			var iterator = col.iterator().reverse();
			var value = iterator.next();
			for (i in iterator) {
				value = func(value, i);
			}

			Some(value);
		}
	}

	inline public static function takeLeft<T>(collection : Collection<T>, amount : Int) : Collection<T> {
		var col = collection;
		return if (amount < 0) {
			Funk.error(Errors.ArgumentError('Amount must be positive'));
		} else if (amount == 0) {
			CollectionsUtil.zero();
		} else if (amount > size(col)) {
			col;
		} else {

			var iterator = col.iterator();

			var stack = [];
			for (i in 0...amount) {
				stack.push(iterator.next());
			}
			CollectionsUtil.toCollection(stack);
		}
	}

	inline public static function takeRight<T>(collection : Collection<T>, amount : Int) : Collection<T> {
		var col = collection;
		return if (amount < 0) {
			Funk.error(Errors.ArgumentError('Amount must be positive'));
		} else if (amount == 0) {
			CollectionsUtil.zero();
		} else if (amount > size(col)) {
			col;
		} else {

			var iterator = col.iterator().reverse();

			var stack = [];
			for (i in 0...amount) {
				stack.push(iterator.next());
			}
			reverse(CollectionsUtil.toCollection(stack));
		}
	}

	inline public static function takeWhile<T>(collection : Collection<T>, func : Predicate1<T>) : Collection<T> {
		var stack = [];
		var col = collection;
		for (i in col.iterator()) {
			if (func(i)) {
				stack.push(i);
			}
		}
		return CollectionsUtil.toCollection(stack);
	}

	inline public static function zip<T1, T2>(	collection : Collection<T1>,
												other : Collection<T2>
												) : Collection<Tuple2<T1, T2>> {
		var col = collection;
		var amount = Std.int(Math.min(size(col), size(other)));

		return if (amount <= 0) {
			CollectionsUtil.zero();
		} else {

			var iterator0 = col.iterator();
			var iterator1 = other.iterator();

			var stack = [];
			for (i in 0...amount) {
				stack.push(tuple2(iterator0.next(), iterator1.next()));
			}

			CollectionsUtil.toCollection(stack);
		}
	}

	inline public static function append<T>(collection : Collection<T>, item : T) : Collection<T> {
		var col = collection;
		var stack = toArray(col);
		stack.push(item);
		return CollectionsUtil.toCollection(stack);
	}

	inline public static function appendAll<T>(collection : Collection<T>, items : Collection<T>) : Collection<T> {
		var col = collection;
		var stack = toArray(col);
		stack = stack.concat(toArray(items));
		return CollectionsUtil.toCollection(stack);
	}

	inline public static function appendIterator<T>(	collection : Collection<T>, 
														iterator : Iterator<T>
														) : Collection<T> {
		var col = collection;
		return appendAll(col, iterator.toCollection());
	}

	inline public static function appendIterable<T>(	collection : Collection<T>, 
														iterable : Iterable<T>
														) : Collection<T> {
		var col = collection;
		return appendIterator(col, iterable.iterator());
	}

	inline public static function prepend<T>(collection : Collection<T>, item : T) : Collection<T> {
		var col = collection;
		var stack = toArray(col);
		stack.unshift(item);
		return CollectionsUtil.toCollection(stack);
	}

	inline public static function prependAll<T>(collection : Collection<T>, items : Collection<T>) : Collection<T> {
		var col = collection;
		var stack = toArray(col);
		stack = toArray(reverse(items)).concat(stack);
		return CollectionsUtil.toCollection(stack);
	}

	inline public static function prependIterator<T>(	collection : Collection<T>, 
														iterator : Iterator<T>
														) : Collection<T> {
		var col = collection;
		return prependAll(col, iterator.toCollection());
	}

	inline public static function prependIterable<T>(	collection : Collection<T>, 
														iterable : Iterable<T>
														) : Collection<T> {
		var col = collection;
		return prependIterator(col, iterable.iterator());
	}

	inline public static function head<T>(collection : Collection<T>) : T {
		var col = collection;
		return if (col.size() < 1) {
			null;
		} else {
			col.iterator().next();
		}
	}

	inline public static function headOption<T>(collection : Collection<T>) : Option<T> {
		var col = collection;
		return if (col.size() < 1) {
			None;
		} else {
			Some(col.iterator().next());
		}
	}

	inline public static function tail<T>(collection : Collection<T>) : Collection<T> {
		var col = collection;
		return if (col.size() < 1) {
			CollectionsUtil.zero();
		} else {
			var iterator = col.iterator();
			iterator.next();
			Iterators.toCollection(iterator);
		}
	}

	inline public static function tailOption<T>(collection : Collection<T>) : Option<Collection<T>> {
		var col = collection;
		var t = tail(col);
		return if (t.size() < 1) {
			None;
		} else {
			Some(t);
		}
	}

	inline public static function reverse<T>(collection : Collection<T>) : Collection<T> {
		var col = collection;
		return Iterators.toCollection(col.iterator().reverse());
	}

	inline public static function size<T>(collection : Collection<T>) : Int {
		var col = collection;
		return col.size();
	}

	inline public static function indices<T>(collection : Collection<T>) : Collection<Int> {
		var stack = [];
		var index = 0;
		var col = collection;
		for (i in col.iterator()) {
			stack.push(index++);
		}
		return CollectionsUtil.toCollection(stack);
	}

	inline public static function init<T>(collection : Collection<T>) : Collection<T> {
		var col = collection;
		return dropRight(col, 1);
	}

	inline public static function last<T>(collection : Collection<T>) : Option<T> {
		var value = None;
		var col = collection;
		for (i in col.iterator()) {
			value = Some(i);
		}
		return value;
	}

	inline public static function zipWithIndex<T>(collection : Collection<T>) : Collection<Tuple2<T, Int>> {
		var col = collection;
		var amount = size(col);

		var stack = [];
		var index = 0;
		for (i in col.iterator()) {
			stack.push(tuple2(i, index++));
		}
		return CollectionsUtil.toCollection(stack);
	}

	inline public static function isEmpty<T>(collection : Collection<T>) : Bool {
		var col = collection;
		return size(col) < 1;
	}

	inline public static function nonEmpty<T>(collection : Collection<T> ) : Bool {
		var col = collection;
		return !isEmpty(col);
	}

	inline public static function hasDefinedSize<T>(collection : Collection<T>) : Bool {
		var col = collection;
		return nonEmpty(col);
	}

	inline public static function iterable<T>(collection : Collection<T>) : Iterable<T> {
		var col = collection;
		return col;
	}

	inline public static function iterator<T>(collection : Collection<T>) : Iterator<T> {
		var col = collection;
		return col.iterator();
	}

	inline public static function toArray<T>(collection : Collection<T>) : Array<T> {
		var col = collection;
		return col.iterator().toArray();
	}

	inline public static function toString<T>(collection : Collection<T>, ?func : Function1<T, String>) : String {
		var col = collection;
		return if (size(col) < 1) {
			'Collection';
		} else {
			var mapped : Collection<String> = map(col, function(value) {
				return Anys.toString(value, func);
			});
			'Collection(' + foldLeftWithIndex(mapped, '', function(a, b, index) {
				return (index < 1) ? b : a + ', ' + b;
			}).get() + ')';
		}
	}
}

