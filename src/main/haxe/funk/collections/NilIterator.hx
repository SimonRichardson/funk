package funk.collections;

import funk.collections.IList;
import funk.collections.IteratorUtil;
import funk.errors.NoSuchElementError;
import funk.FunkObject;
import funk.option.Option;
import funk.product.Product;

using funk.collections.mutable.Nil;

class NilIterator<T> extends Product, implements IFunkObject {
	
	private var _factory : ICollectionFactory<T>;
	
	public function new(factory : ICollectionFactory<T>) {
		super();
		
		_factory = factory;
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
	
	override public function equals(that: IFunkObject): Bool {
      	return IteratorUtil.eq(this, that);
    }
	
	override public function productElement(index : Int) : Dynamic {
		throw new NoSuchElementError();
	}
	
	override private function get_productArity() : Int {
		return 0;
	}

	override private function get_productPrefix() : String {
		return "NilIterator";
	}
}

private typedef NilIteratorAccess<T> = {
	var _factory : IListFactory<T>;
}

class NilIteratorType {
	
	inline public static function toArray<T>(iter : NilIterator<T>) : Array<T> {
		return [];
	}
	
	inline public static function toList<T>(iter : NilIterator<T>) : IList<T> {
		var access : NilIteratorAccess<T> = cast iter;
		return cast access._factory.createNil();
	}
}