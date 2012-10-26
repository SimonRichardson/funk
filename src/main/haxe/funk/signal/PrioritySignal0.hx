package funk.signal;

import funk.Funk;
import funk.collections.immutable.List;
import funk.collections.immutable.Nil;
import funk.option.Option;

using funk.collections.immutable.Nil;

class PrioritySignal0 extends PrioritySignal {

	public function new() {
		super();
	}

    public function addWithPriority(listener : Function, ?priority : Int = 0) : IOption<ISlot0> {
        return registerListenerWithPriority(listener, false, priority);
    }

    public function addOnceWithPriority(listener : Function, ?priority:Int = 0) : IOption<ISlot0> {
        return registerListenerWithPriority(listener, true, priority);
    }

    private function registerListenerWithPriority(	listener : Function0<Void>,
    												once : Bool,
    												priority : Int) : IOption<ISlot0> {
    	if(registrationPossible(listener, once)) {
    		var added : Bool = false;
    		var slot : ISlot0 = new PrioritySlot0(this, func, once, priority);

			_list = _list.flatMap(function(value : ISlot0) {
				var prioritySlot : PrioritySlot0 = cast value;

				var list = Nil.toList().prepend(value);
				return if(prioritySlot.priority == priority) {
					added = true;
					list.prepend(slot);
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
}

class PrioritySlot0 extends Slot0 {

	public var priority(get_priority, never) : Int;

	private var _priority : Int;

	public function new(listener : Function0<Void>, once : Bool, priority : Int) {
		super(listener, once);

		_priority = priority;
	}

	private function get_priority() : Int {
		return _priority;
	}

}
