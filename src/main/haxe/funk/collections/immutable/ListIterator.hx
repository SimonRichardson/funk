package funk.collections.immutable;

import funk.errors.NoSuchElementError;
import funk.option.Any;
import funk.option.Option;
import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.collections.IteratorUtil;
import funk.FunkObject;
import funk.product.Product;
import funk.product.ProductIterator;

using funk.option.Any;
using funk.option.Option;
using funk.collections.immutable.Nil;

class ListIterator<T> extends Product, implements IFunkObject, implements IProductIterator<T> {
	
	private var _list : IList<T>;
	
	public function new(l : IList<T>) {
		super();
		
		_list = l;
	}
	
	public function hasNext() : Bool {
		return _list == null ? false : _list.nonEmpty;
	}
	
	public function next() : T {
		return if(_list == nil.list()) {
			throw new NoSuchElementError();
		} else {
			var head : T = _list.head;
			_list = _list.tail;
			head;
		}
	}
	
	public function nextOption() : Option<T> {
		return if(_list == nil.list()) {
			None;
		} else {
			var head : Option<T> = _list.headOption;
			_list = _list.tail;
			head;
		}
	}
	
	override public function equals(that: IFunkObject): Bool {
      	return IteratorUtil.eq(this, that);
    }
	
	override public function productElement(index : Int) : Dynamic {
		return _list.productElement(index);
	}
	
	override private function get_productArity() : Int {
		return _list.size;
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