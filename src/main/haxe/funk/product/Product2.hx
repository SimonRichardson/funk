package funk.product;

import funk.IFunkObject;

class Product2<T1, T2> extends Product {
	
	public function new() {
		super();
	}
	
	override public function equals(that: IFunkObject): Bool {
      	if (Std.is(that, Product2)) {
        	var thatProduct: Product2 = cast that;
        	return productElement(0) == thatProduct.productElement(0) &&
        			productElement(1) == thatProduct.productElement(1);
      	}

      	return false;
    }
	
	override private function get_productArity() : Int {
		return 2;
	}

	override private function get_productPrefix() : String {
		return "Product2";
	}
}
