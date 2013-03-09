package funk.signals;

import funk.Funk;

using funk.signals.Signal1;
using funk.types.Function1;
using funk.types.Option;
using funk.collections.immutable.List;

class PrioritySignal1<T1> extends Signal1<T1> {

	public function new() {
		super();
	}

    public function addWithPriority(	func : Function1<T1, Void>,
    									?priority : Int = 0) : Option<Slot1<T1>> {
        return registerListenerWithPriority(func, false, priority);
    }

    public function addOnceWithPriority(	func : Function1<T1, Void>,
    										?priority:Int = 0) : Option<Slot1<T1>> {
        return registerListenerWithPriority(func, true, priority);
    }

    private function registerListenerWithPriority(	func : Function1<T1, Void>,
    												once : Bool,
    												priority : Int) : Option<Slot1<T1>> {
    	if(registrationPossible(func, once)) {
    		var added : Bool = false;
    		var slot : Slot1<T1> = new PrioritySlot1<T1>(this, func, once, priority);

			_list = _list.flatMap(function(value : Slot1<T1>) {
				var prioritySlot : PrioritySlot1<T1> = cast value;

				var list = Nil.prepend(value);
				return if(priority >= prioritySlot.getPriority()) {
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

    	return _list.find(function(s : Slot1<T1>) : Bool {
			return Reflect.compareMethods(s.getListener(), func);
		});
    }
}

class PrioritySlot1<T1> extends Slot1<T1> {

	private var _priority : Int;

	public function new(	signal : Signal1<T1>,
							listener : Function1<T1, Void>,
							once : Bool,
							priority : Int) {
		super(signal, listener, once);

		_priority = priority;
	}

	public function getPriority() : Int {
		return _priority;
	}

}
