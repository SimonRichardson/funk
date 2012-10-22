package funk.signal;

import funk.Funk;
import funk.errors.RangeError;
import funk.signal.Slot;
import funk.signal.Signal0;

interface ISlot0 implements ISlot {

	var listener(default, default) : Function0<Void>;

	function execute() : Void;
}

class Slot0 extends Slot, implements ISlot0 {

	public var listener(default, default) : Function0<Void>;

	private var _signal : ISignal0;

	public function new(signal : ISignal0, listener : Function0<Void>, once : Bool) {
		super();

		_signal = signal;

		this.listener = listener;
		this.once = once;
	}

	public function execute() : Void {
		if(!enabled) {
			return;
		}
		if(once) {
			remove();
		}

		listener();
	}

	override public function remove() : Void {
		_signal.remove(listener);
	}

	public function productElement(index : Int) : Dynamic {
		return switch(index){
			case 0: listener;
			default:
				throw new RangeError();
		}
	}

	override private function get_productArity() : Int {
		return 1;
	}
}
