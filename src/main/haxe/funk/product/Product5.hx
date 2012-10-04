package funk.product;

import funk.IFunkObject;

class Product5<T1, T2, T3, T4, T5> extends Product {

	public function new() {
		super();
	}

	override private function get_productArity() : Int {
		return 5;
	}

	override private function get_productPrefix() : String {
		return "Product5";
	}
}
