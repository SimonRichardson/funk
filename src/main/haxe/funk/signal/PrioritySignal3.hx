package funk.signal;

import funk.Funk;
import funk.collections.IList;
import funk.collections.immutable.List;
import funk.collections.immutable.Nil;
import funk.option.Option;
import funk.signal.Signal3;

using funk.collections.immutable.Nil;
using funk.option.Option;

class PrioritySignal3<T1, T2, T3> extends Signal3<T1, T2, T3>, implements IPrioritySignal {

	public function new() {
		super();
	}

    public function addWithPriority(	func : Function3<T1, T2, T3, Void>,
    									?priority : Int = 0) : IOption<ISlot3<T1, T2, T3>> {
        return registerListenerWithPriority(func, false, priority);
    }

    public function addOnceWithPriority(	func : Function3<T1, T2, T3, Void>,
    										?priority:Int = 0) : IOption<ISlot3<T1, T2, T3>> {
        return registerListenerWithPriority(func, true, priority);
    }

    private function registerListenerWithPriority(	func : Function3<T1, T2, T3, Void>,
    												once : Bool,
    												priority : Int) : IOption<ISlot3<T1, T2, T3>> {
    	if(registrationPossible(func, once)) {
    		var added : Bool = false;
    		var slot : ISlot3<T1, T2, T3> = new PrioritySlot3<T1, T2, T3>(	this,
    																		func,
    																		once,
    																		priority);

			_list = _list.flatMap(function(value : ISlot3<T1, T2, T3>) {
				var prioritySlot : PrioritySlot3<T1, T2, T3> = cast value;

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

    	return _list.find(function(s : ISlot3<T1, T2, T3>) : Bool {
			return listenerEquals(s.listener, func);
		});
    }

    override private function get_productPrefix() : String {
		return "PrioritySignal3";
	}
}

class PrioritySlot3<T1, T2, T3> extends Slot3<T1, T2, T3> {

	public var priority(get_priority, never) : Int;

	private var _priority : Int;

	public function new(	signal : ISignal3<T1, T2, T3>,
							listener : Function3<T1, T2, T3, Void>,
							once : Bool,
							priority : Int) {
		super(signal, listener, once);

		_priority = priority;
	}

	private function get_priority() : Int {
		return _priority;
	}

}
