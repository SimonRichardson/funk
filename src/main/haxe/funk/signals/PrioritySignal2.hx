package funk.signals;

import funk.Funk;

using funk.signals.Signal2;
using funk.types.Function2;
using funk.types.Option;
using funk.ds.immutable.List;

class PrioritySignal2<T1, T2> extends Signal2<T1, T2> {

    public function new() {
        super();
    }

    public function addWithPriority(    func : Function2<T1, T2, Void>,
                                        ?priority : Int = 0) : Option<Slot2<T1, T2>> {
        return registerListenerWithPriority(func, false, priority);
    }

    public function addOnceWithPriority(    func : Function2<T1, T2, Void>,
                                            ?priority:Int = 0) : Option<Slot2<T1, T2>> {
        return registerListenerWithPriority(func, true, priority);
    }

    private function registerListenerWithPriority(    func : Function2<T1, T2, Void>,
                                                    once : Bool,
                                                    priority : Int) : Option<Slot2<T1, T2>> {
        if(registrationPossible(func, once)) {
            var added : Bool = false;
            var slot : Slot2<T1, T2> = new PrioritySlot2<T1, T2>(this, func, once, priority);

            _list = _list.flatMap(function(value : Slot2<T1, T2>) {
                var prioritySlot : PrioritySlot2<T1, T2> = cast value;

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

        return _list.find(function(s : Slot2<T1, T2>) : Bool {
            return Reflect.compareMethods(s.getListener(), func);
        });
    }
}

class PrioritySlot2<T1, T2> extends Slot2<T1, T2> {

    private var _priority : Int;

    public function new(    signal : Signal2<T1, T2>,
                            listener : Function2<T1, T2, Void>,
                            once : Bool,
                            priority : Int) {
        super(signal, listener, once);

        _priority = priority;
    }

    public function getPriority() : Int {
        return _priority;
    }

}
