package funk.product;

import funk.collections.IteratorUtil;
import funk.option.Option;
import funk.product.Product;
import funk.FunkObject;

interface IProductIterator<T> implements IFunkObject {
	
	function hasNext() : Bool;
	
	function next() : T;
}

class ProductIterator<T> implements IProductIterator<T> {
	
	private var _index : Int;
	
	private var _arity : Int;
	
	private var _product : IProduct;
	
	public function new(product : IProduct){
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
	
	public function equals(that: IFunkObject): Bool {
      	return IteratorUtil.eq(this, that);
    }
}
