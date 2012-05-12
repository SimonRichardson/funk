package funk.collections.immutable;

import funk.option.Option;
import funk.collections.IList;
import funk.collections.immutable.Nil;

class NilIterator<T> implements Iterator<T> {
	
	public function new() {
	}
	
	public function hasNext() : Bool {
		return false;
	}
	
	public function next() : IOption<T> {
		return None();
	}
}

class NilIteratorType {
	
	inline public static function toArray<T>(iter : NilIterator<T>) : Array<T> {
		return [];
	}
	
	inline public static function toList<T>(iter : NilIterator<T>) : IList<T> {
		return nil();
	}
}