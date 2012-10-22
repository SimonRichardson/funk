package funk.signal;

import funk.Funk;
import funk.errors.RangeError;
import funk.signal.Slot;
import funk.signal.Signal4;

interface ISlot4<T1, T2, T3, T4> implements ISlot {

	var listener(default, default) : Function4<T1, T2, T3, T4, Void>;

	function execute(value0 : T1, value1 : T2, value2 : T3, value3 : T4) : Void;
}

class Slot4<T1, T2, T3, T4> extends Slot, implements ISlot4<T1, T2, T3, T4> {

	public var listener(default, default) : Function4<T1, T2, T3, T4, Void>;

	private var _signal : ISignal4<T1, T2, T3, T4>;

	public function new(	signal : ISignal4<T1, T2, T3, T4>,
							listener : Function4<T1, T2, T3, T4, Void>,
							once : Bool) {
		super();

		_signal = signal;

		this.listener = listener;
		this.once = once;
	}

	public function execute(value0 : T1, value1 : T2, value2 : T3, value3 : T4) : Void {
		if(!enabled) {
			return;
		}
		if(once) {
			remove();
		}

		listener(value0, value1, value2, value3);
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
