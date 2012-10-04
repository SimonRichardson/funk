package funk.product;

import funk.IFunkObject;
import funk.errors.AbstractMethodError;
import funk.product.ProductIterator;

interface IProduct implements IFunkObject {

	var productArity(dynamic, never) : Int;

	var productPrefix(dynamic, never) : String;

	function productElement(index : Int) : Dynamic;

	function productIterator() : IProductIterator<Dynamic>;
}

class Product implements IProduct {

	public var productArity(get_productArity, null) : Int;

	public var productPrefix(get_productPrefix, null) : String;

	public function new() {

	}

    public function equals(that: IFunkObject): Bool {
      	if (Std.is(that, IProduct)) {
        	var thatProduct: IProduct = cast that;
        	if(productArity == thatProduct.productArity) {
        		for(i in 0...productArity) {
        			if(productElement(i) != thatProduct.productElement(i)) {
        				return false;
        			}
        		}
        		return true;
        	}
      	}

      	return false;
    }

	public function productElement(index : Int) : Dynamic {
		throw new AbstractMethodError();
	}

	public function productIterator() : IProductIterator<Dynamic> {
		return new ProductIterator<Dynamic>(this);
	}

	private function makeString(separator : String) : String {
		var total : Int = productArity;
		var last : Int = total - 1;

		var buffer : StringBuf = new StringBuf();
		for(i in 0...total) {
			buffer.add(productElement(i));

			if(i < last) {
				buffer.add(separator);
			}
		}

		return buffer.toString();
	}

	private function get_productArity() : Int {
		throw new AbstractMethodError();
		return -1;
	}

	private function get_productPrefix() : String {
		throw new AbstractMethodError();
		return "";
	}

	public function toString() : String {
		return if(0 == productArity) {
			productPrefix;
		} else {
			Std.format("$productPrefix(${makeString(\",\")})");
		}
	}

}
