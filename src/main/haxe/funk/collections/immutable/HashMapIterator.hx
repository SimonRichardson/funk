package funk.collections.immutable;

class HashMapIterator<K, V> {
	
	private var _set : ISet<K, V>;
	
	public function new(l : ISet<K, V>) {
		_set = l;
	}
	
	public function hasNext() : Bool {
		return _set.nonEmpty;
	}
	
	public function next() : ITuple2<K, V> {
		return if(_set == nil.instance()) {
			throw new NoSuchElementError();
		} else {
			var head : ITuple2<K, V> = _set.head;
			_set = _set.tail;
			head;
		}
	}
	
	public function nextOption() : Option<ITuple2<K, V>> {
		return if(_list == nil.instance()) {
			None;
		} else {
			var head : Option<ITuple2<K, V>> = _list.headOption;
			_list = _list.tail;
			head;
		}
	}
}

class HashMapIteratorType {
	
	inline public static function toArray<ITuple2<K, V>>(iter : ListIterator<K, V>) : Array<ITuple2<K, V>> {
		return IteratorUtil.toArray(iter);
	}
	
	inline public static function toList<T>(iter : ListIterator<K, V>) : IList<ITuple2<K, V>> {
		return IteratorUtil.toList(iter);
	}
}