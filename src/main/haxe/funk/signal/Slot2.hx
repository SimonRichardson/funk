package funk.signal;

import funk.signal.Slot;
import funk.signal.Signal2;

interface ISlot2<A, B> implements ISlot {
	
	var listener(default, default) : (A -> B -> Void);
	
	function execute(a : A, b : B) : Void;
}

class Slot2<A, B> extends Slot, implements ISlot2<A, B> {
	
	public var listener(default, default) : (A -> B -> Void);
	
	private var _signal : ISignal2<A, B>;
	
	public function new(signal : ISignal2<A, B>, listener : (A -> B -> Void), once : Bool) {
		super();
		
		_signal = signal;
		
		this.listener = listener;
		this.once = once;
	}
	
	public function execute(a : A, b : B) : Void {
		if(!enabled) return;
		if(once) remove();
		
		listener(a, b);
	}
	
	override public function remove() : Void {
		_signal.remove(listener);
	}
}
