package funk.signal;

import funk.product.Product;

interface ISignal implements IProduct {

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

	override private function get_productArity() : Int {
		return size;
	}

	override private function get_productPrefix() : String {
		return "Signal";
	}
}

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

	override private function get_productArity() : Int {
		return -1;
	}

	override private function get_productPrefix() : String {
		return "Slot";
	}
}

