package funk.signal;

import funk.errors.RangeError;
import funk.signal.Signal5;

interface ISlot5<T1, T2, T3, T4, T5> implements ISlot {

	var listener(default, default) : T1 -> T2 -> T3 -> T4 -> T5 -> Void;

	function execute(value0 : T1, value1 : T2, value2 : T3, value3 : T4, value : T5) : Void;
}

class Slot5<T1, T2, T3, T4, T5> extends Slot, implements ISlot5<T1, T2, T3, T4, T5> {

	public var listener(default, default) : T1 -> T2 -> T3 -> T4 -> T5 -> Void;

	private var _signal : ISignal5<T1, T2, T3, T4, T5>;

	public function new(	signal : ISignal5<T1, T2, T3, T4, T5>,
							listener : T1 -> T2 -> T3 -> T4 -> T5 -> Void,
							once : Bool) {
		super();

		_signal = signal;

		this.listener = listener;
		this.once = once;
	}

	public function execute(	value0 : T1,
								value1 : T2,
								value2 : T3,
								value3 : T4,
								value4 : T5) : Void {
		if(!enabled) {
			return;
		}
		if(once) {
			remove();
		}

		listener(value0, value1, value2, value3, value4);
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
