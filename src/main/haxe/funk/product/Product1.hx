package funk.product;

import funk.IFunkObject;
import funk.product.Product;

class Product1<T1> extends Product {

	public function new() {
		super();
	}

	override private function get_productArity() : Int {
		return 1;
	}

	override private function get_productPrefix() : String {
		return "Product1";
	}
}
