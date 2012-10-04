package funk.product;

import funk.IFunkObject;

class Product3<T1, T2, T3> extends Product {

	public function new() {
		super();
	}

	override private function get_productArity() : Int {
		return 3;
	}

	override private function get_productPrefix() : String {
		return "Product3";
	}
}
