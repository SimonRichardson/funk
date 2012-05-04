package funk;

import funk.option.Option;
import funk.Product;

interface IProductIterator<T> {
	
	function hasNext() : Bool;
	
	function next() : T;
}

class ProductIterator<T> implements IProductIterator<T> {
	
	private var _index : Int;
	
	private var _arity : Int;
	
	private var _product : IProduct<T>;
	
	public function new(product : IProduct<T>){
		_index = 0;
		_product = product;
		_arity = product.productArity;
	}
	
	public function hasNext() : Bool {
		return _index < _arity;
	}
	
	public function next() : T {
		return _product.productElement(_index++);
		//return _index < _arity ? Some(_product.productElement(_index++)) : None;
	}
}
