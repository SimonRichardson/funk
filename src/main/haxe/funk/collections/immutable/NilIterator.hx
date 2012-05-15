package funk.collections.immutable;

import funk.option.Option;
import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.collections.IteratorUtil;
import funk.FunkObject;

using funk.collections.immutable.Nil;

class NilIterator<T> implements FunkObject {
	
	public function new() {
	}
	
	public function hasNext() : Bool {
		return false;
	}
	
	public function next() : T {
		return null;
	}
	
	public function nextOption() : Option<T> {
		return None;
	}
	
	public function equals(that: IFunkObject): Bool {
      	return IteratorUtil.eq(this, that);
    }
}

class NilIteratorType {
	
	inline public static function toArray<T>(iter : NilIterator<T>) : Array<T> {
		return [];
	}
	
	inline public static function toList<T>(iter : NilIterator<T>) : IList<T> {
		return nil.list();
	}
}