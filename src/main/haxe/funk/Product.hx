package funk;

import funk.ProductIterator;

interface IProduct<T> {
	
	var productArity(dynamic, never) : Int;
	
	var productPrefix(dynamic, never) : String;
	
	function productElement(index : Int) : T;
	
	function iterator() : IProductIterator<T>;
}

class Product<T> implements IProduct<T> {
	
	public var productArity(get_productArity, null) : Int;
	
	public var productPrefix(get_productPrefix, null) : String;
	
	@abstract
	public function productElement(index : Int) : T {
		return null;
	}
	
	public function iterator() : IProductIterator<T> {
		return new ProductIterator<T>(this);
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
	
	@abstract
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
		
		return productPrefix + "(" + makeString(",") + ")";
	}
}