package funk.signals;

import funk.Funk;
import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;
import funk.types.Function5;
import haxe.ds.Option;
import funk.types.extensions.Functions5;
import funk.types.extensions.Options;
import funk.signals.Signal5;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Functions5;
using funk.types.extensions.Options;

class PrioritySignal5<T1, T2, T3, T4, T5> extends Signal5<T1, T2, T3, T4, T5> {

	public function new() {
		super();
	}

    public function addWithPriority(	func : Function5<T1, T2, T3, T4, T5, Void>,
    									?priority : Int = 0) : Option<Slot5<T1, T2, T3, T4, T5>> {
        return registerListenerWithPriority(func, false, priority);
    }

    public function addOnceWithPriority(	func : Function5<T1, T2, T3, T4, T5, Void>,
    										?priority:Int = 0
    										) : Option<Slot5<T1, T2, T3, T4, T5>> {
        return registerListenerWithPriority(func, true, priority);
    }

    private function registerListenerWithPriority(	func : Function5<T1, T2, T3, T4, T5, Void>,
    												once : Bool,
    												priority : Int
    												) : Option<Slot5<T1, T2, T3, T4, T5>> {
    	if(registrationPossible(func, once)) {
    		var added : Bool = false;
    		var slot : Slot5<T1, T2, T3, T4, T5> = new PrioritySlot5<T1, T2, T3, T4, T5>(	this,
    																		func,
    																		once,
    																		priority);

			_list = _list.flatMap(function(value : Slot5<T1, T2, T3, T4, T5>) {
				var prioritySlot : PrioritySlot5<T1, T2, T3, T4, T5> = cast value;

				var list = Nil.prepend(value);
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

			return Some(slot);
    	}

    	return _list.find(function(s : Slot5<T1, T2, T3, T4, T5>) : Bool {
			return Reflect.compareMethods(s.listener, func);
		});
    }
}

class PrioritySlot5<T1, T2, T3, T4, T5> extends Slot5<T1, T2, T3, T4, T5> {

	public var priority(get_priority, never) : Int;

	private var _priority : Int;

	public function new(	signal : Signal5<T1, T2, T3, T4, T5>,
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
