package funk.product;

import funk.IFunkObject;

class Product5<T1, T2, T3, T4, T5> extends Product {
	
	public function new() {
		super();
	}
	
	override public function equals(that: IFunkObject): Bool {
      	if (Std.is(that, Product5)) {
        	var thatProduct: Product5 = cast that;
        	return productElement(0) == thatProduct.productElement(0) &&
        			productElement(1) == thatProduct.productElement(1) && 
        			productElement(2) == thatProduct.productElement(2) && 
        			productElement(3) == thatProduct.productElement(3) && 
        			productElement(4) == thatProduct.productElement(4);
      	}

      	return false;
    }
	
	override private function get_productArity() : Int {
		return 5;
	}

	override private function get_productPrefix() : String {
		return "Product5";
	}
}
