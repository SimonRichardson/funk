package funk.signal;

import funk.Funk;
import funk.collections.IList;
import funk.collections.immutable.List;
import funk.collections.immutable.Nil;
import funk.option.Option;
import funk.signal.Signal0;

using funk.collections.immutable.Nil;
using funk.option.Option;

class PrioritySignal0 extends Signal0, implements IPrioritySignal {

	public function new() {
		super();
	}

    public function addWithPriority(func : Function0<Void>, ?priority : Int = 0) : IOption<ISlot0> {
        return registerListenerWithPriority(func, false, priority);
    }

    public function addOnceWithPriority(	func : Function0<Void>,
    										?priority:Int = 0) : IOption<ISlot0> {
        return registerListenerWithPriority(func, true, priority);
    }

    private function registerListenerWithPriority(	func : Function0<Void>,
    												once : Bool,
    												priority : Int) : IOption<ISlot0> {
    	if(registrationPossible(func, once)) {
    		var added : Bool = false;
    		var slot : ISlot0 = new PrioritySlot0(this, func, once, priority);

			_list = _list.flatMap(function(value : ISlot0) {
				var prioritySlot : PrioritySlot0 = cast value;

				var list = Nil.list().prepend(value);
				return if(priority >= prioritySlot.priority) {
					added = true;
					list.append(slot);
				} else {
					list;
				};
			});

			if(!added) {
				_list = _list.prepend(slot);
			}

			return Some(slot).toInstance();
    	}

    	return _list.find(function(s : ISlot0) : Bool {
			return listenerEquals(s.listener, func);
		});
    }

    override private function get_productPrefix() : String {
		return "PrioritySignal0";
	}
}

class PrioritySlot0 extends Slot0, implements ISlot0 {

	public var priority(get_priority, never) : Int;

	private var _priority : Int;

	public function new(signal : ISignal0, listener : Function0<Void>, once : Bool, priority : Int) {
		super(signal, listener, once);

		_priority = priority;
	}

	private function get_priority() : Int {
		return _priority;
	}

}
