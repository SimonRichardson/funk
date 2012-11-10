package funk.signal;

import funk.Funk;
import funk.collections.IList;
import funk.collections.immutable.List;
import funk.collections.immutable.Nil;
import funk.option.Option;
import funk.signal.Signal4;

using funk.collections.immutable.Nil;
using funk.option.Option;

class PrioritySignal4<T1, T2, T3, T4> extends Signal4<T1, T2, T3, T4>, implements IPrioritySignal {

	public function new() {
		super();
	}

    public function addWithPriority(	func : Function4<T1, T2, T3, T4, Void>,
    									?priority : Int = 0) : IOption<ISlot4<T1, T2, T3, T4>> {
        return registerListenerWithPriority(func, false, priority);
    }

    public function addOnceWithPriority(	func : Function4<T1, T2, T3, T4, Void>,
    										?priority:Int = 0) : IOption<ISlot4<T1, T2, T3, T4>> {
        return registerListenerWithPriority(func, true, priority);
    }

    private function registerListenerWithPriority(	func : Function4<T1, T2, T3, T4, Void>,
    												once : Bool,
    												priority : Int
    												) : IOption<ISlot4<T1, T2, T3, T4>> {
    	if(registrationPossible(func, once)) {
    		var added : Bool = false;
    		var slot : ISlot4<T1, T2, T3, T4> = new PrioritySlot4<T1, T2, T3, T4>(	this,
    																		func,
    																		once,
    																		priority);

			_list = _list.flatMap(function(value : ISlot4<T1, T2, T3, T4>) {
				var prioritySlot : PrioritySlot4<T1, T2, T3, T4> = cast value;

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

    	return _list.find(function(s : ISlot4<T1, T2, T3, T4>) : Bool {
			return listenerEquals(s.listener, func);
		});
    }

    override private function get_productPrefix() : String {
		return "PrioritySignal4";
	}
}

class PrioritySlot4<T1, T2, T3, T4> extends Slot4<T1, T2, T3, T4> {

	public var priority(get_priority, never) : Int;

	private var _priority : Int;

	public function new(	signal : ISignal4<T1, T2, T3, T4>,
							listener : Function4<T1, T2, T3, T4, Void>,
							once : Bool,
							priority : Int) {
		super(signal, listener, once);

		_priority = priority;
	}

	private function get_priority() : Int {
		return _priority;
	}

}
