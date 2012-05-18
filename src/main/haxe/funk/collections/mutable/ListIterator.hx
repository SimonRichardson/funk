package funk.collections.mutable;

import funk.errors.NoSuchElementError;
import funk.option.Option;
import funk.collections.IList;
import funk.collections.mutable.Nil;
import funk.collections.IteratorUtil;
import funk.FunkObject;
import funk.product.Product;

using funk.option.Option;
using funk.collections.mutable.Nil;

class ListIterator<T> extends Product, implements IFunkObject {
	
	private var _array : Array<T>;
	
	public function new(l : IList<T>) {
		super();
		
		_array = l.toArray;
	}
	
	public function hasNext() : Bool {
		return _array.length > 0;
	}
	
	public function next() : T {
		return if(_array.length == 0) {
			throw new NoSuchElementError();
		} else {
			_array.shift();
		}
	}
	
	public function nextOption() : Option<T> {
		return if(_array.length == 0) {
			None;
		} else {
			Some(_array.shift());
		}
	}
	
	override public function equals(that: IFunkObject): Bool {
      	return IteratorUtil.eq(this, that);
    }
	
	override public function productElement(index : Int) : Dynamic {
		if(index >= 0 && index < _array.length) {
			return _array[index];
		}
		
		throw new NoSuchElementError();
	}
	
	override private function get_productArity() : Int {
		return _array.length;
	}

	override private function get_productPrefix() : String {
		return "ListIterator";
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