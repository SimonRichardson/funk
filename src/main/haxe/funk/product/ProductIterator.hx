package funk.product;

import funk.IFunkObject;
import funk.option.Option;
import funk.product.Product;
import funk.errors.NoSuchElementError;
import funk.errors.IllegalOperationError;

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
		return if(this == that) {
			true;
		} else if(Std.is(that, IProduct)) {
			super.equals(that);
		} else {
			false;
		}
    }

	override public function productElement(index : Int) : Dynamic {
		return _product.productElement(index);
	}

	override private function get_productArity() : Int {
		return _arity;
	}

	override private function get_productPrefix() : String {
		return "ProductIterator";
	}
}

class ProxyProductIterator<T> extends Product, implements IProductIterator<T> {

	private var _iterator : Iterator<T>;

	public function new(iterator : Iterator<T>){
		super();

		_iterator = iterator;
	}

	public function hasNext() : Bool {
		return _iterator.hasNext();
	}

	public function next() : T {
		return _iterator.next();
	}

	override public function equals(that: IFunkObject): Bool {
		return if(Std.is(_iterator, IFunkObject)) {
			var funkIterator : IFunkObject = cast _iterator;
			funkIterator.equals(that);
		} else {
			false;
		}
    }

	override public function productElement(index : Int) : Dynamic {
		return if(Std.is(_iterator, IProduct)) {
			var productIterator : IProduct = cast _iterator;
			productIterator.productElement(index);
		} else {
			throw new IllegalOperationError();
		}
	}

	override private function get_productArity() : Int {
		return if(Std.is(_iterator, IProduct)) {
			var productIterator : IProduct = cast _iterator;
			productIterator.productArity;
		} else {
			throw new IllegalOperationError();
		}
	}

	override private function get_productPrefix() : String {
		return if(Std.is(_iterator, IProduct)) {
			var productIterator : IProduct = cast _iterator;
			productIterator.productPrefix;
		} else {
			"ProxyProductIterator";
		}
	}
}
