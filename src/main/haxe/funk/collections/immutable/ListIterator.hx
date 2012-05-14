package funk.collections.immutable;

import funk.errors.NoSuchElementError;
import funk.option.Option;
import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.collections.IteratorUtil;

using funk.option.Option;
using funk.collections.immutable.Nil;

class ListIterator<T> {
	
	private var _list : IList<T>;
	
	public function new(l : IList<T>) {
		_list = l;
	}
	
	public function hasNext() : Bool {
		return _list.nonEmpty;
	}
	
	public function next() : T {
		return if(_list == nil.instance()) {
			throw new NoSuchElementError();
		} else {
			var head : T = _list.head;
			_list = _list.tail;
			head;
		}
	}
	
	public function nextOption() : Option<T> {
		return if(_list == nil.instance()) {
			None;
		} else {
			var head : Option<T> = _list.headOption;
			_list = _list.tail;
			head;
		}
	}
}

class ListIteratorType {
	
	inline public static function toArray<T>(iter : ListIterator<T>) : Array<T> {
		return IteratorUtil.toArray(iter);
	}
	
	inline public static function toList<T>(iter : ListIterator<T>) : IList<T> {
		return IteratorUtil.toList(iter);
	}
}