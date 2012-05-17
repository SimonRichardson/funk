package funk.signal;

import funk.signal.Slot;
import funk.signal.Signal1;

interface ISlot1<A> implements ISlot {
	
	var listener(default, default) : (A -> Void);
	
	function execute(a : A) : Void;
}

class Slot1<A> extends Slot, implements ISlot1<A> {
	
	public var listener(default, default) : (A -> Void);
	
	private var _signal : ISignal1<A>;
	
	public function new(signal : ISignal1<A>, listener : (A -> Void), once : Bool) {
		super();
		
		_signal = signal;
		
		this.listener = listener;
		this.once = once;
	}
	
	public function execute(a : A) : Void {
		if(!enabled) return;
		if(once) remove();
		
		listener(a);
	}
	
	override public function remove() : Void {
		_signal.remove(listener);
	}
}
