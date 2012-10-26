package funk.signal;

import funk.Funk;
import funk.collections.IList;
import funk.collections.immutable.List;
import funk.collections.immutable.Nil;
import funk.option.Option;
import funk.signal.Signal2;

using funk.collections.immutable.Nil;
using funk.option.Option;

class PrioritySignal2<T1, T2> extends Signal2<T1, T2>, implements IPrioritySignal {

	public function new() {
		super();
	}

    public function addWithPriority(	func : Function2<T1, T2, Void>,
    									?priority : Int = 0) : IOption<ISlot2<T1, T2>> {
        return registerListenerWithPriority(func, false, priority);
    }

    public function addOnceWithPriority(	func : Function2<T1, T2, Void>,
    										?priority:Int = 0) : IOption<ISlot2<T1, T2>> {
        return registerListenerWithPriority(func, true, priority);
    }

    private function registerListenerWithPriority(	func : Function2<T1, T2, Void>,
    												once : Bool,
    												priority : Int) : IOption<ISlot2<T1, T2>> {
    	if(registrationPossible(func, once)) {
    		var added : Bool = false;
    		var slot : ISlot2<T1, T2> = new PrioritySlot2<T1, T2>(this, func, once, priority);

			_list = _list.flatMap(function(value : ISlot2<T1, T2>) {
				var prioritySlot : PrioritySlot2<T1, T2> = cast value;

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

    	return _list.find(function(s : ISlot2<T1, T2>) : Bool {
			return listenerEquals(s.listener, func);
		});
    }

    override private function get_productPrefix() : String {
		return "PrioritySignal";
	}
}

class PrioritySlot2<T1, T2> extends Slot2<T1, T2> {

	public var priority(get_priority, never) : Int;

	private var _priority : Int;

	public function new(	signal : ISignal2<T1, T2>,
							listener : Function2<T1, T2, Void>,
							once : Bool,
							priority : Int) {
		super(signal, listener, once);

		_priority = priority;
	}

	private function get_priority() : Int {
		return _priority;
	}

}
