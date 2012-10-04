package funk.product;

import funk.IFunkObject;

class Product4<T1, T2, T3, T4> extends Product {

	public function new() {
		super();
	}

	override private function get_productArity() : Int {
		return 4;
	}

	override private function get_productPrefix() : String {
		return "Product4";
	}
}
