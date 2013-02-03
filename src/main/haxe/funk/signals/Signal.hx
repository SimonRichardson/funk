package funk.signals;

class Signal {

	public function new() {
	}

	public function removeAll() : Void {
	}

	public function size() : Int {
		return -1;
	}
}

class Slot {

	public var once(default, default) : Bool;

	public var enabled(default, default) : Bool;

	public function new() {
		this.enabled = true;
	}

	public function remove() : Void {
	}
}

