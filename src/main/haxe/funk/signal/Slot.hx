package funk.signal;
import funk.product.Product;

interface ISlot implements Product {
	var once(default, default) : Bool;
}

class Slot extends Product, implements ISlot {
	
	public var once(default, default) : Bool;
	
	public function new() {
		super();
	}
	
	override private function get_productPrefix() : String {
		return "Slot";
	}
}
