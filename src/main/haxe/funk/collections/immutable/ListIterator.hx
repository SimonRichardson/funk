package funk.collections.immutable;

import funk.option.Option;
import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.collections.IteratorUtil;

class ListIterator<T> implements Iterator<T> {
	
	private var _list : IList<T>;
	
	public function new(l : IList<T>) {
		_list = l;
	}
	
	public function hasNext() : Bool {
		return _list.nonEmpty;
	}
	
	public function next() : IOption<T> {
		return if(_list == nil()) {
			None();
		} else {
			var head : T = _list.head;
			_list = _list.tail;
			Some(head);
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