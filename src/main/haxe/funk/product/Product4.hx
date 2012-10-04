package funk.product;

import funk.IFunkObject;

class Product4<T1, T2, T3, T4> extends Product {
	
	public function new() {
		super();
	}
	
	override public function equals(that: IFunkObject): Bool {
      	if (Std.is(that, Product4)) {
        	var thatProduct: Product4 = cast that;
        	return productElement(0) == thatProduct.productElement(0) &&
        			productElement(1) == thatProduct.productElement(1) && 
        			productElement(2) == thatProduct.productElement(2) && 
        			productElement(3) == thatProduct.productElement(3);
      	}

      	return false;
    }
	
	override private function get_productArity() : Int {
		return 4;
	}

	override private function get_productPrefix() : String {
		return "Product4";
	}
}
