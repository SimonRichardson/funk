package funk.signal;

import funk.Funk;
import funk.errors.RangeError;
import funk.signal.Slot;
import funk.signal.Signal3;

interface ISlot3<T1, T2, T3> implements ISlot {

	var listener(default, default) : Function3<T1, T2, T3, Void>;

	function execute(value0 : T1, value1 : T2, value2 : T3) : Void;
}

class Slot3<T1, T2, T3> extends Slot, implements ISlot3<T1, T2, T3> {

	public var listener(default, default) : Function3<T1, T2, T3, Void>;

	private var _signal : ISignal3<T1, T2, T3>;

	public function new(	signal : ISignal3<T1, T2, T3>,
							listener : Function3<T1, T2, T3, Void>,
							once : Bool) {
		super();

		_signal = signal;

		this.listener = listener;
		this.once = once;
	}

	public function execute(value0 : T1, value1 : T2, value2 : T3) : Void {
		if(!enabled) {
			return;
		}
		if(once) {
			remove();
		}

		listener(value0, value1, value2);
	}

	override public function remove() : Void {
		_signal.remove(listener);
	}

	override public function productElement(index : Int) : Dynamic {
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
