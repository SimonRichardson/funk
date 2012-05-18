package funk.product;

import funk.collections.IteratorUtil;
import funk.option.Option;
import funk.product.Product;
import funk.FunkObject;
import funk.errors.NoSuchElementError;

interface IProductIterator<T> implements IFunkObject {
	
	function hasNext() : Bool;
	
	function next() : T;
}

class ProductIterator<T> extends Product, implements IProductIterator<T> {
	
	private var _index : Int;
	
	private var _arity : Int;
	
	private var _product : IProduct;
	
	public function new(product : IProduct){
		super();
		
		_index = 0;
		_product = product;
		_arity = product.productArity;
	}
	
	public function hasNext() : Bool {
		return _index < _arity;
	}
	
	public function next() : T {
		return _product.productElement(_index++);
	}
	
	override public function equals(that: IFunkObject): Bool {
      	return IteratorUtil.eq(this, that);
    }
	
	override public function productElement(index : Int) : Dynamic {
		return _product.productElement(_index);
	}
	
	override private function get_productArity() : Int {
		return _arity;
	}

	override private function get_productPrefix() : String {
		return "ProductIterator";
	}
}
