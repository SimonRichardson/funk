package funk.collections.immutable.extensions;

import funk.Funk;
import funk.collections.extensions.Collections;
import funk.collections.immutable.List;
import funk.collections.immutable.extensions.IteratorsUtil;
import funk.types.Function1;
import funk.types.Option;
import funk.types.Predicate1;
import funk.types.Predicate2;
import funk.types.Tuple2;

using funk.collections.immutable.extensions.IteratorsUtil;

private class ListImpl<T> {

	private var _list : List<T>;

	public function new(list : List<T>) {
		_list = list;
	}

	public function iterator() : Iterator<T> {
		return new ListImplIterator<T>(_list);
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

	public static function contains<T>(list : List<T>, item : T, ?func : Predicate2<T, T>) : Bool {
		var eq = function(a, b) {
			return null != func ? func(a, b) : a == b;
		};

		while(nonEmpty(list)) {
			if (eq(head(list), item)) {
				return true;
			}
			list = tail(list);
		}
		return false;
	}

	public static function count<T>(list : List<T>, func : Predicate1<T>) : Int {
		var counter = 0;
		while(nonEmpty(list)) {
			if (func(head(list))) {
				counter++;
			}
			list = tail(list);
		}
		return counter;
	}

	public static function drop<T>(list : List<T>, amount : Int) : List<T> {
		if (amount < 0) {
			Funk.error(Errors.ArgumentError('Amount must be positive'));
		}

		var stack = list;
		for(i in 0...amount) {
			if (isEmpty(stack)) {
				return Nil;
			}
			stack = tail(stack);
		}

		return stack;
	}

	public static function dropRight<T>(list : List<T>, amount : Int) : List<T> {
		if (amount < 0) {
			Funk.error(Errors.ArgumentError('Amount must be positive'));
		} else if (amount == 0) {
			return list;
		}

		amount = size(list) - amount;
		if (amount <= 0) {
			return Nil;
		}

		var stack = Nil;
		for (i in 0...amount) {
			var h = head(list);
			list = tail(list);
			stack = prepend(stack, h);
		}

		return reverse(stack);
	}

	public static function dropWhile<T>(list : List<T>, func : Predicate1<T>) : List<T> {
		while (nonEmpty(list)) {
			if (!func(head(list))) {
				return list;
			}

			list = tail(list);
		}

		return Nil;
	}

	public static function get<T>(list : List<T>, index : Int) : Option<T> {
		if (index < 0 || index > size(list)) {
			return None;
		}

		var stack = list;
		while(nonEmpty(stack)) {
			if (index == 0) {
				return headOption(stack);
			}

			index--;
			stack = tail(stack);
		}

		return None;
	}

	public static function append<T>(list : List<T>, item : T) : List<T> {
		return appendAll(list, Cons(item, Nil));
	}

	public static function appendAll<T>(list : List<T>, items : List<T>) : List<T> {
		var result = items;

		var stack = reverse(list);
		while(nonEmpty(stack)) {
			result = Cons(head(stack), result);
			stack = tail(stack);
		}

		return result;
	}

	public static function appendIterator<T>(list : List<T>, iterator : Iterator<T>) : List<T> {
		return appendAll(list, iterator.toList());
	}

	public static function appendIterable<T>(list : List<T>, iterable : Iterable<T>) : List<T> {
		return appendIterator(list, iterable.iterator());
	}

	public static function prepend<T>(list : List<T>, item : T) : List<T> {
		return Cons(item, list);
	}

	public static function prependAll<T>(list : List<T>, items : List<T>) : List<T> {
		var result = list;

		while(nonEmpty(items)) {
			result = Cons(head(items), result);
			items = tail(items);
		}

		return result;
	}

	public static function prependIterator<T>(list : List<T>, iterator : Iterator<T>) : List<T> {
		return prependAll(list, iterator.toList());
	}

	public static function prependIterable<T>(list : List<T>, iterable : Iterable<T>) : List<T> {
		return prependIterator(list, iterable.iterator());
	}

	public static function head<T>(list : List<T>) : T {
		return switch(list) {
			case Nil: null;
			case Cons(head, _): head;
		}
	}

	public static function headOption<T>(list : List<T>) : Option<T> {
		return switch(list) {
			case Nil: None;
			case Cons(head, _): Some(head);
		}
	}

	public static function tail<T>(list : List<T>) : List<T> {
		return switch(list) {
			case Nil: null;
			case Cons(_, tail): tail;
		}
	}

	public static function tailOption<T>(list : List<T>) : Option<List<T>> {
		return switch(list) {
			case Nil: None;
			case Cons(_, tail): Some(tail);
		}
	}

	public static function reverse<T>(list : List<T>) : List<T> {
		var stack = Nil;
		var valid = true;
		while(valid) {
			switch(list) {
				case Nil:
					valid = false;
				case Cons(head, tail):
					stack = Cons(head, stack);
					list = tail;
			}
		}
		return stack;
	}

	public static function size<T>(list : List<T>) : Int {
		var count = 0;

		while(nonEmpty(list)) {
			count++;
			list = tail(list);
		}

		return count;
	}

	public static function indices<T>(list : List<T>) : List<Int> {
		var n = size(list);
		var stack = Nil;
		while(--n > -1) {
			stack = prepend(stack, n);
		}
		return stack;
	}

	public static function init<T>(list : List<T>) : List<T> {
		return dropRight(list, 1);
	}

	public static function last<T>(list : List<T>) : Option<T> {
		var value = None;

		while(nonEmpty(list)) {
			value = headOption(list);
			list = tail(list);
		}

		return value;
	}

	public static function zipWithIndex<T>(list : List<T>) : List<Tuple2<T, Int>> {
		var amount = size(list);

		var stack = Nil;
		for (i in 0...amount) {
			var h = head(list);
			list = tail(list);
			stack = prepend(stack, tuple2(h, i));
		}

		return reverse(stack);
	}

	public static function isEmpty<T>(list : List<T>) : Bool {
		return switch(list) {
			case Nil:
				true;
			case Cons(_, _):
				false;
		};
	}

	public static function nonEmpty<T>(list : List<T>) : Bool {
		return !isEmpty(list);
	}

	public static function hasDefinedSize<T>(list : List<T>) : Bool {
		return switch (list) {
			case Nil: false;
			case Cons(_, _): true;
		};
	}

	public static function iterable<T>(list : List<T>) : Iterable<T> {
		return new ListImpl(list);
	}

	public static function iterator<T>(list : List<T>) : Iterator<T> {
		return new ListImplIterator(list);
	}

	public static function toString<T>(list : List<T>, ?func : Function1<T, String>) : String {
		var mapper : Function1<T, String> = function(value) {
			return null != func ? func(value) : '' + value;
		};
		var mapped : Iterable<String> = Collections.map({
			iterator: function() {
				return iterator(list);
			}
		}, function(value) {
			return mapper(value);
		});
		return 'List(' + Collections.foldLeftWithIndex(mapped, '', function(a, b, index) {
			return (index < 1) ? b : a + ', ' + b;
		}) + ')';
	}

}
