package funk.product;

import funk.IFunkObject;

class Product2<T1, T2> extends Product {

	public function new() {
		super();
	}

	override private function get_productArity() : Int {
		return 2;
	}

	override private function get_productPrefix() : String {
		return "Product2";
	}
}
