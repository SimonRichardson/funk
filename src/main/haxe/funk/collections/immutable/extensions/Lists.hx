package funk.collections.immutable.extensions;

import funk.Funk;
import funk.collections.Collection;
import funk.collections.extensions.Collections;
import funk.collections.immutable.List;
import funk.types.Function1;
import funk.types.Function2;
import funk.types.Option;
import funk.types.Predicate1;
import funk.types.Predicate2;
import funk.types.Tuple2;
import funk.types.extensions.Anys;
import funk.types.extensions.Iterators;
import funk.types.extensions.Options;

using funk.types.extensions.Iterators;
using funk.types.extensions.Options;

private class ListImpl<T> {

	private var _list : List<T>;

	private var _knownSize : Bool;

	private var _size : Int;

	public function new(list : List<T>) {
		_list = list;

		_size = 0;
		_knownSize = false;
	}

	public function productArity() : Int {
		return size();
	}

	public function productPrefix() : String {
		return size() > 0 ? 'List' : 'Nil';
	}

	public function productElement(index : Int) : Option<T> {
		return Lists.get(_list, index);
	}

	public function iterator() : Iterator<T> {
		return new ListImplIterator<T>(_list);
	}

	public function size() : Int {
		if (_knownSize) {
			return _size;
		}

		_size = Lists.size(_list);
		_knownSize = true;

		return _size;
	}
}

private class ListImplIterator<T> {

	private var _list : List<T>;

	public function new(list : List<T>) {
		_list = list;
	}

	public function hasNext() : Bool {
		return Lists.nonEmpty(_list);
	}

	public function next() : T {
		return if (Lists.nonEmpty(_list)) {
			var value = Lists.head(_list);
			_list = Lists.tail(_list);
			value;
		} else {
			Funk.error(Errors.NoSuchElementError);
		}
	}
}

class Lists {

	inline public static function contains<T>(list : List<T>, item : T, ?func : Predicate2<T, T>) : Bool {
		var eq = function(a, b) {
			return null != func ? func(a, b) : a == b;
		};

		var result = false;
		var p = list;
		while(nonEmpty(p)) {
			if (eq(head(p), item)) {
				result = true;
				break;
			}
			p = tail(p);
		}
		return result;
	}

	inline public static function count<T>(list : List<T>, func : Predicate1<T>) : Int {
		var counter = 0;

		var p = list;
		while (nonEmpty(p)) {
			if (func(head(p))) {
				counter++;
			}
			p = tail(p);
		}
		return counter;
	}

	inline public static function dropLeft<T>(list : List<T>, amount : Int) : List<T> {
		if (amount < 0) {
			Funk.error(Errors.ArgumentError('Amount must be positive'));
		}

		var p = list;
		var result = p;

		if (amount > 0) {
			for (i in 0...amount) {
				if (isEmpty(p)) {
					result = Nil;
					break;
				}
				p = tail(p);
				result = p;
			}
		}

		return result;
	}

	inline public static function dropRight<T>(list : List<T>, amount : Int) : List<T> {
		var p = list;

		return if (amount < 0) {
			Funk.error(Errors.ArgumentError('Amount must be positive'));
		} else if (amount == 0) {
			p;
		} else {

			amount = size(p) - amount;
			if (amount <= 0) {
				Nil;
			} else {

				var stack = Nil;
				for (i in 0...amount) {
					var h = head(p);
					p = tail(p);
					stack = prepend(stack, h);
				}

				reverse(stack);
			}
		}
	}

	inline public static function dropWhile<T>(list : List<T>, func : Predicate1<T>) : List<T> {
		var p = list;
		var result = Nil;
		while (nonEmpty(p)) {
			if (!func(head(p))) {
				result = p;
				break;
			}

			p = tail(p);
		}

		return result;
	}

	inline public static function exists<T>(list : List<T>, func : Predicate1<T>) : Bool {
		var p = list;
		var result = false;
		while (nonEmpty(p)) {
			if (func(head(p))) {
				result = true;
				break;
			}
			p = tail(p);
		}

		return result;
	}

	inline public static function flatMap<T1, T2>(list : List<T1>, func : Function1<T1, List<T2>>) : List<T2> {
		var stack = Nil;
		var p = list;
		while (nonEmpty(p)) {
			stack = prependAll(stack, func(head(p)));
			p = tail(p);
		}
		return reverse(stack);
	}

	inline public static function flatten<T1, T2>(list : List<T1>) : List<T2> {
		var p = list;
		return flatMap(p, function(x) {
			return ListsUtil.toList(x);
		});
	}

	inline public static function filter<T>(list : List<T>, func : Predicate1<T>) : List<T> {
		var stack = Nil;
		var allFiltered = true;

		var p = list;
		var all = list;
		while (nonEmpty(p)) {
			var h = head(p);

			p = tail(p);

			if (func(h)) {
				stack = prepend(stack, h);
			} else {
				allFiltered = false;
			}
		}

		return if (allFiltered) {
			all;
		} else {
			reverse(stack);
		}
	}

	inline public static function filterNot<T>(list : List<T>, func : Predicate1<T>) : List<T> {
		var stack = Nil;
		var allFiltered = true;

		var p = list;
		var all = list;
		while (nonEmpty(p)) {
			var h = head(p);

			p = tail(p);

			if (!func(h)) {
				stack = prepend(stack, h);
			} else {
				allFiltered = false;
			}
		}

		return if (allFiltered) {
			all;
		} else {
			reverse(stack);
		}
	}

	inline public static function find<T>(list : List<T>, func : Predicate1<T>) : Option<T> {
		var result = None;
		var p = list;
		while (nonEmpty(p)) {
			if (func(head(p))) {
				result = headOption(p);
				break;
			}
			p = tail(p);
		}
		return result;
	}

	inline public static function findIndexOf<T>(list : List<T>, func : Predicate1<T>) : Int {
		var index = 0;
		var p = list;
		var result = -1;
		while (nonEmpty(p)) {
			if (func(head(p))) {
				result = index;
				break;
			}
			index++;
			p = tail(p);
		}
		return result;
	}

	inline public static function foldLeft<T>(list : List<T>, value : T, func : Function2<T, T, T>) : Option<T> {
		var p = list;
		while (nonEmpty(p)) {
			value = func(value, head(p));
			p = tail(p);
		}
		return Some(value);
	}

	inline public static function foldRight<T>(list : List<T>, value : T, func : Function2<T, T, T>) : Option<T> {
		var p = list;
		p = reverse(p);
		while (nonEmpty(p)) {
			value = func(value, head(p));
			p = tail(p);
		}
		return Some(value);
	}

	inline public static function forall<T>(list : List<T>, func : Predicate1<T>) : Bool {
		var p = list;
		var result = true;
		while (nonEmpty(p)) {
			if (!func(head(p))) {
				result = false;
				break;
			}
			p = tail(p);
		}
		return result;
	}

	inline public static function foreach<T>(list : List<T>, func : Function1<T, Void>) : Void {
		var p = list;
		while (nonEmpty(p)) {
			func(head(p));
			p = tail(p);
		}
	}

	inline public static function get<T>(list : List<T>, index : Int) : Option<T> {
		var p = list;
		return if (index < 0 || index > size(p)) {
			None;
		} else {

			var result = None;
			while (nonEmpty(p)) {
				if (index == 0) {
					result = headOption(p);
					break;
				}

				index--;
				p = tail(p);
			}

			result;
		}
	}

	inline public static function indexOf<T>(list : List<T>, value : T) : Int {
		var index = 0;
		var p = list;
		var result = -1;
		while (nonEmpty(p)) {
			if (Anys.equals(head(p), value)) {
				result = index;
				break;
			}
			index++;
			p = tail(p);
		}
		return result;
	}

	inline public static function map<T, E>(list : List<T>, func : Function1<T, E>) : List<E> {
		var stack = Nil;
		var p = list;
		while (nonEmpty(p)) {
			stack = prepend(stack, func(head(p)));
			p = tail(p);
		}
		return reverse(stack);
	}

	inline public static function partition<T>(list : List<T>, func : Predicate1<T>) : Tuple2<List<T>, List<T>> {
		var left = Nil;
		var right = Nil;

		var p = list;
		while (nonEmpty(p)) {
			var h = head(p);
			if (func(h)) {
				left = prepend(left, h);
			} else {
				right = prepend(right, h);
			}
			p = tail(p);
		}

		return tuple2(reverse(left), reverse(right));
	}

	inline public static function reduceLeft<T>(list : List<T>, func : Function2<T, T, T>) : Option<T> {
		var p = list;
		return if (size(p) < 1) {
			None;
		} else {

			var value = head(p);
			p = tail(p);
			while (nonEmpty(p)) {
				value = func(value, head(p));
				p = tail(p);
			}

			Some(value);
		}
	}

	inline public static function reduceRight<T>(list : List<T>, func : Function2<T, T, T>) : Option<T> {
		var p = list;
		return if (size(p) < 1) {
			None;
		} else {

			p = reverse(p);
			var value = head(p);
			p = tail(p);
			while (nonEmpty(p)) {
				value = func(value, head(p));
				p = tail(p);
			}
			
			Some(value);
		}
	}

	inline public static function takeLeft<T>(list : List<T>, amount : Int) : List<T> {
		var p = list;
		return if (amount < 0) {
			Funk.error(Errors.ArgumentError('Amount must be positive'));
		} else if (amount == 0) {
			Nil;
		} else if (amount > size(p)) {
			p;
		} else {

			var stack = Nil;
			for (i in 0...amount) {
				stack = prepend(stack, head(p));
				p = tail(p);
			}

			reverse(stack);
		}
	}

	inline public static function takeRight<T>(list : List<T>, amount : Int) : List<T> {
		var p = list;
		return if (amount < 0) {
			Funk.error(Errors.ArgumentError('Amount must be positive'));
		} else if (amount == 0) {
			Nil;
		} else if (amount > size(p)) {
			p;
		} else {

			p = reverse(p);

			var stack = Nil;
			for (i in 0...amount) {
				stack = prepend(stack, head(p));
				p = tail(p);
			}

			stack;
		}
	}

	inline public static function takeWhile<T>(list : List<T>, func : Predicate1<T>) : List<T> {
		var stack = Nil;
		var p = list;
		while (nonEmpty(p)) {
			var h = head(p);
			if (func(h)) {
				stack = prepend(stack, h);
			}
			p = tail(p);
		}
		return reverse(stack);
	}

	inline public static function zip<T1, T2>(list : List<T1>, other : List<T2>) : List<Tuple2<T1, T2>> {
		var p = list;
		var amount = Std.int(Math.min(size(p), size(other)));

		return if (amount <= 0) {
			Nil;
		} else {

			var stack = Nil;
			for (i in 0...amount) {
				stack = prepend(stack, tuple2(head(p), head(other)));
				p = tail(p);
				other = tail(other);
			}

			reverse(stack);
		}
	}


	inline public static function append<T>(list : List<T>, item : T) : List<T> {
		var p = list;
		return appendAll(p, Cons(item, Nil));
	}

	inline public static function appendAll<T>(list : List<T>, items : List<T>) : List<T> {
		var result = items;
		var p = list;

		var stack = reverse(p);
		while(nonEmpty(stack)) {
			result = Cons(head(stack), result);
			stack = tail(stack);
		}

		return result;
	}

	inline public static function appendIterator<T>(list : List<T>, iterator : Iterator<T>) : List<T> {
		var p = list;
		return appendAll(p, iterator.toList());
	}

	inline public static function appendIterable<T>(list : List<T>, iterable : Iterable<T>) : List<T> {
		var p = list;
		return appendIterator(p, iterable.iterator());
	}

	inline public static function prepend<T>(list : List<T>, item : T) : List<T> {
		var p = list;
		return Cons(item, p);
	}

	inline public static function prependAll<T>(list : List<T>, items : List<T>) : List<T> {
		var p = list;
		var result = p;

		while(nonEmpty(items)) {
			result = Cons(head(items), result);
			items = tail(items);
		}

		return result;
	}

	inline public static function prependIterator<T>(list : List<T>, iterator : Iterator<T>) : List<T> {
		var p = list;
		return prependAll(p, iterator.toList());
	}

	inline public static function prependIterable<T>(list : List<T>, iterable : Iterable<T>) : List<T> {
		var p = list;
		return prependIterator(p, iterable.iterator());
	}

	inline public static function head<T>(list : List<T>) : T {
		var p = list;
		return switch(p) {
			case Nil: null;
			case Cons(head, _): head;
		}
	}

	inline public static function headOption<T>(list : List<T>) : Option<T> {
		var p = list;
		return if (null == p) {
			None;
		} else {
			switch(p) {
				case Nil: None;
				case Cons(head, _): Some(head);
			}
		}
	}

	inline public static function tail<T>(list : List<T>) : List<T> {
		var p = list;
		return if (null == p) {
			null;
		} else {
			switch(p) {
				case Nil: null;
				case Cons(_, tail): tail;
			}
		}
	}

	inline public static function tailOption<T>(list : List<T>) : Option<List<T>> {
		var p = list;
		return if (null == p) {
			None;
		} else {
			switch(p) {
				case Nil: None;
				case Cons(_, tail): Some(tail);
			}
		}
	}

	inline public static function reverse<T>(list : List<T>) : List<T> {
		var p = list;
		var stack = Nil;
		var valid = true;
		while(valid) {
			switch(p) {
				case Nil:
					valid = false;
				case Cons(head, tail):
					stack = Cons(head, stack);
					p = tail;
			}
		}
		return stack;
	}

	inline public static function size<T>(list : List<T>) : Int {
		var count = 0;

		var p = list;
		while(nonEmpty(p)) {
			count++;
			p = tail(p);
		}

		return count;
	}

	inline public static function indices<T>(list : List<T>) : List<Int> {
		var p = list;
		var n = size(p);
		var stack = Nil;
		while(--n > -1) {
			stack = prepend(stack, n);
		}
		return stack;
	}

	inline public static function init<T>(list : List<T>) : List<T> {
		var p = list;
		return dropRight(p, 1);
	}

	inline public static function last<T>(list : List<T>) : Option<T> {
		var value = None;

		var p = list;
		while(nonEmpty(p)) {
			value = headOption(p);
			p = tail(p);
		}

		return value;
	}

	inline public static function zipWithIndex<T>(list : List<T>) : List<Tuple2<T, Int>> {
		var p = list;
		var amount = size(p);

		var stack = Nil;
		for (i in 0...amount) {
			var h = head(p);
			p = tail(p);
			stack = prepend(stack, tuple2(h, i));
		}

		return reverse(stack);
	}

	inline public static function isEmpty<T>(list : List<T>) : Bool {
		var p = list;
		return switch(p) {
			case Nil: true;
			case Cons(_, _): false;
		};
	}

	inline public static function nonEmpty<T>(list : List<T>) : Bool {
		var p = list;
		return !isEmpty(p);
	}

	inline public static function hasDefinedSize<T>(list : List<T>) : Bool {
		var p = list;
		return switch (p) {
			case Nil: false;
			case Cons(_, _): true;
		};
	}

	inline public static function collection<T>(list : List<T>) : Collection<T> {
		var p = list;
		return new ListImpl(p);
	}

	inline public static function iterable<T>(list : List<T>) : Iterable<T> {
		var p = list;
		return new ListImpl(p);
	}

	inline public static function iterator<T>(list : List<T>) : Iterator<T> {
		var p = list;
		return new ListImplIterator(p);
	}

	inline public static function toString<T>(list : List<T>, ?func : Function1<T, String>) : String {
		var p = list;
		return switch(p) {
			case Nil: 'Nil';
			case Cons(_, _):
				var mapped : Collection<String> = Collections.map(collection(p), function(value) {
					return Anys.toString(value, func);
				});

				'List(' + Collections.foldLeftWithIndex(mapped, '', function(a, b, index) {
					return (index < 1) ? b : a + ', ' + b;
				}).get() + ')';
		}
	}

}
