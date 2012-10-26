package funk.signal;

import funk.Funk;
import funk.collections.IList;
import funk.collections.immutable.List;
import funk.collections.immutable.Nil;
import funk.option.Option;
import funk.signal.Signal5;

using funk.collections.immutable.Nil;
using funk.option.Option;

class PrioritySignal5<T1, T2, T3, T4, T5> extends Signal5<T1, T2, T3, T4, T5>,
											implements IPrioritySignal {

	public function new() {
		super();
	}

    public function addWithPriority(	func : Function5<T1, T2, T3, T4, T5, Void>,
    									?priority : Int = 0) : IOption<ISlot5<T1, T2, T3, T4, T5>> {
        return registerListenerWithPriority(func, false, priority);
    }

    public function addOnceWithPriority(	func : Function5<T1, T2, T3, T4, T5, Void>,
    										?priority:Int = 0
    										) : IOption<ISlot5<T1, T2, T3, T4, T5>> {
        return registerListenerWithPriority(func, true, priority);
    }

    private function registerListenerWithPriority(	func : Function5<T1, T2, T3, T4, T5, Void>,
    												once : Bool,
    												priority : Int
    												) : IOption<ISlot5<T1, T2, T3, T4, T5>> {
    	if(registrationPossible(func, once)) {
    		var added : Bool = false;
    		var slot : ISlot5<T1, T2, T3, T4, T5> = new PrioritySlot5<T1, T2, T3, T4, T5>(	this,
    																		func,
    																		once,
    																		priority);

			_list = _list.flatMap(function(value : ISlot5<T1, T2, T3, T4, T5>) {
				var prioritySlot : PrioritySlot5<T1, T2, T3, T4, T5> = cast value;

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

    	return _list.find(function(s : ISlot5<T1, T2, T3, T4, T5>) : Bool {
			return listenerEquals(s.listener, func);
		});
    }

    override private function get_productPrefix() : String {
		return "PrioritySignal";
	}
}

class PrioritySlot5<T1, T2, T3, T4, T5> extends Slot5<T1, T2, T3, T4, T5> {

	public var priority(get_priority, never) : Int;

	private var _priority : Int;

	public function new(	signal : ISignal5<T1, T2, T3, T4, T5>,
							listener : Function5<T1, T2, T3, T4, T5, Void>,
							once : Bool,
							priority : Int) {
		super(signal, listener, once);

		_priority = priority;
	}

	private function get_priority() : Int {
		return _priority;
	}

}
