package funk.product;

import funk.IFunkObject;
import funk.product.Product;

class Product1<T1> extends Product {

	public function new() {
		super();
	}

	override public function equals(that: IFunkObject): Bool {
      	if (Std.is(that, Product1)) {
        	var thatProduct: Product1 = cast that;
        	return productElement(0) == thatProduct.productElement(0);
      	}

      	return false;
    }

	override private function get_productArity() : Int {
		return 1;
	}

	override private function get_productPrefix() : String {
		return "Product1";
	}
}
