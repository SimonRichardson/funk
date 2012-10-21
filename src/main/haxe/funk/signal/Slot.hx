package funk.signal;

import funk.product.Product;

interface ISlot implements IProduct {

	var once(default, default) : Bool;

	var enabled(default, default)  : Bool;

	function remove() : Void;
}

class Slot extends Product, implements ISlot {

	public var once(default, default) : Bool;

	public var enabled(default, default) : Bool;

	public function new() {
		super();

		this.enabled = true;
	}

	public function remove() : Void {

	}

	override private function get_productPrefix() : String {
		return "Slot";
	}
}
