package funk.signal;
import funk.product.Product;

interface ISignal {	
	
	var size(dynamic, never) : Int;
	
	function removeAll() : Void;
}

class Signal extends Product, implements ISignal {
	
	public var size(get_size, never) : Int;
	
	public function new() {
		super();
	}
	
	public function removeAll() : Void {
		
	}
	
	private function get_size() : Int {
		return -1;
	}
	
	override private function get_productPrefix() : String {
		return "Signal";
	}
}