package funk.signal;

import funk.Funk;
import funk.collections.IList;
import funk.collections.immutable.List;
import funk.collections.immutable.Nil;
import funk.option.Option;
import funk.signal.Signal1;

using funk.collections.immutable.Nil;
using funk.option.Option;

class PrioritySignal1<T1> extends Signal1<T1>, implements IPrioritySignal {

	public function new() {
		super();
	}

    public function addWithPriority(	func : Function1<T1, Void>,
    									?priority : Int = 0) : IOption<ISlot1<T1>> {
        return registerListenerWithPriority(func, false, priority);
    }

    public function addOnceWithPriority(	func : Function1<T1, Void>,
    										?priority:Int = 0) : IOption<ISlot1<T1>> {
        return registerListenerWithPriority(func, true, priority);
    }

    private function registerListenerWithPriority(	func : Function1<T1, Void>,
    												once : Bool,
    												priority : Int) : IOption<ISlot1<T1>> {
    	if(registrationPossible(func, once)) {
    		var added : Bool = false;
    		var slot : ISlot1<T1> = new PrioritySlot1<T1>(this, func, once, priority);

			_list = _list.flatMap(function(value : ISlot1<T1>) {
				var prioritySlot : PrioritySlot1<T1> = cast value;

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

    	return _list.find(function(s : ISlot1<T1>) : Bool {
			return listenerEquals(s.listener, func);
		});
    }

    override private function get_productPrefix() : String {
		return "PrioritySignal";
	}
}

class PrioritySlot1<T1> extends Slot1<T1> {

	public var priority(get_priority, never) : Int;

	private var _priority : Int;

	public function new(	signal : ISignal1<T1>,
							listener : Function1<T1, Void>,
							once : Bool,
							priority : Int) {
		super(signal, listener, once);

		_priority = priority;
	}

	private function get_priority() : Int {
		return _priority;
	}

}
