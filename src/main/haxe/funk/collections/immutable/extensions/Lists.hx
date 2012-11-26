package funk.collections.immutable.extensions;

import funk.Funk;
import funk.collections.extensions.Collections;
import funk.collections.immutable.List;
import funk.types.Option;

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

	public static function prepend<T>(list : List<T>, item : T) : List<T> {
		var stack : List<T> = Cons(item, Nil);

		while(nonEmpty(list)) {
			stack = Cons(head(list), stack);
			list = tail(list);
		}

		return stack;
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

	public static function size<T>(list : List<T>) : Int {
		var count = 0;

		var p : List<T> = list;
		while(nonEmpty(p)) {
			count++;
			p = tail(p);
		}

		return count;
	}

	public static function isEmpty<T>(list : List<T>) : Bool {
		return switch(list) {
			case Nil: 
				true;
			case Cons(_):
				false;
		};
	}

	public static function nonEmpty<T>(list : List<T>) : Bool {
		return !isEmpty(list);
	}

	public static function iterator<T>(list : List<T>) : Iterator<T> {
		return new ListImplIterator(list);
	}

	public static function toString<T>(list : List<T>) : String {
		var mapped : Iterable<String> = Collections.map({
			iterator: function() {
				return iterator(list);
			}
		}, function(value) {
			return '' + value;
		});
		return 'List(' + Collections.foldLeftWithIndex(mapped, '', function(a, b, index) {
			return (index < 1) ? b : a + ', ' + b;
		}) + ')';
	}

}