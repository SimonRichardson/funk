package funk.product;

import funk.product.ProductIterator;

interface IProduct {

	var productArity(dynamic, never) : Int;
	
	var productPrefix(dynamic, never) : String;
	
	function productElement(index : Int) : Dynamic;
	
	function iterator() : IProductIterator<Dynamic>;
}

class Product implements IProduct {
	
	public var productArity(get_productArity, null) : Int;
	
	public var productPrefix(get_productPrefix, null) : String;
	
	public function new() {
		
	}
	
	public function productElement(index : Int) : Dynamic {
		return null;
	}
	
	public function iterator() : IProductIterator<Dynamic> {
		return new ProductIterator<Dynamic>(this);
	}
	
	@:final
	private function makeString(separator : String) : String {
		var total : Int = productArity;
		var last : Int = total - 1;
		
		var buffer : StringBuf = new StringBuf();
		for(i in 0...total) {
			buffer.add(productElement(0));
			
			if(i < last) {
				buffer.add(separator);
			}
		}
		
		return buffer.toString();
	}
	
	private function get_productArity() : Int {
		return -1;
	}

	private function get_productPrefix() : String {
		return "";
	}
	
	@:final
	public function toString() : String {
		if(0 == productArity) {
			return productPrefix;
		}
		
		return Std.format("$productPrefix(${makeString(\",\")})");
	}
}
