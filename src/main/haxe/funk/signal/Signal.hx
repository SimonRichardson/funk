package funk.signal;

interface ISignal {

	var size(dynamic, never) : Int;

	function removeAll() : Void;
}

class Signal implements ISignal {

	public var size(get_size, never) : Int;

	public function new() {
		super();
	}

	public function removeAll() : Void {

	}

	private function get_size() : Int {
		return -1;
	}
}

class Slot {

	public var once(default, default) : Bool;

	public var enabled(default, default) : Bool;

	public function new() {
		super();

		this.enabled = true;
	}

	public function remove() : Void {

	}
}

