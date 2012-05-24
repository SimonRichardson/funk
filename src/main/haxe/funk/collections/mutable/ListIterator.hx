package funk.collections.mutable;

import funk.errors.NoSuchElementError;
import funk.option.Option;
import funk.collections.IList;
import funk.collections.mutable.Nil;
import funk.collections.IteratorUtil;
import funk.FunkObject;
import funk.product.Product;
import funk.product.ProductIterator;

using funk.option.Option;
using funk.collections.mutable.Nil;

private typedef MutableList<T> = {
	var _data : Array<T>;
}

class ListIterator<T> extends Product, implements IFunkObject, implements IProductIterator<T> {
	
	private var _array : Array<T>;
	
	private var _pointer : Int;
	
	public function new(l : IList<T>) {
		super();
		
		var mutable : MutableList<T> = cast l;
		_array = mutable._data;
		_pointer = _array.length - 1;
	}
	
	public function hasNext() : Bool {
		return _pointer >= 0;
	}
	
	public function next() : T {
		return if(_pointer < 0) {
			throw new NoSuchElementError();
		} else {
			_array[_pointer--];
		}
	}
	
	public function nextOption() : Option<T> {
		return if(_pointer < 0) {
			None;
		} else {
			Some(_array[_pointer--]);
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