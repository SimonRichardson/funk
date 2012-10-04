package funk.product;

import funk.IFunkObject;

class Product3<T1, T2, T3> extends Product {
	
	public function new() {
		super();
	}
	
	override public function equals(that: IFunkObject): Bool {
      	if (Std.is(that, Product3)) {
        	var thatProduct: Product3 = cast that;
        	return productElement(0) == thatProduct.productElement(0) &&
        			productElement(1) == thatProduct.productElement(1) && 
        			productElement(2) == thatProduct.productElement(2);
      	}

      	return false;
    }
	
	override private function get_productArity() : Int {
		return 3;
	}

	override private function get_productPrefix() : String {
		return "Product3";
	}
}
