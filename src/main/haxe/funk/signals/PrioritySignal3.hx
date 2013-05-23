package funk.signals;

import funk.Funk;

using funk.signals.Signal3;
using funk.types.Function3;
using funk.types.PartialFunction3;
using funk.types.Option;
using funk.ds.immutable.List;

class PrioritySignal3<T1, T2, T3> extends Signal3<T1, T2, T3> {

    public function new() {
        super();
    }

    public function addWithPriority(    func : PartialFunction3<T1, T2, T3, Void>,
                                        ?priority : Int = 0) : Option<Slot3<T1, T2, T3>> {
        return registerListenerWithPriority(func, false, priority);
    }

    public function addOnceWithPriority(    func : PartialFunction3<T1, T2, T3, Void>,
                                            ?priority:Int = 0) : Option<Slot3<T1, T2, T3>> {
        return registerListenerWithPriority(func, true, priority);
    }

    private function registerListenerWithPriority(  func : PartialFunction3<T1, T2, T3, Void>,
                                                    once : Bool,
                                                    priority : Int) : Option<Slot3<T1, T2, T3>> {
        if(registrationPossible(func, once)) {
            var added : Bool = false;
            var slot : Slot3<T1, T2, T3> = new PrioritySlot3<T1, T2, T3>(    this,
                                                                            func,
                                                                            once,
                                                                            priority);

            _list = _list.flatMap(function(value : Slot3<T1, T2, T3>) {
                var prioritySlot : PrioritySlot3<T1, T2, T3> = cast value;

                var list = Nil.prepend(value);
                return if(priority >= prioritySlot.priority()) {
                    added = true;
                    list.append(slot);
                } else list;
            });

            if(!added) _list = _list.prepend(slot);
            
            return Some(slot);
        }

        return _list.find(function(s : Slot3<T1, T2, T3>) : Bool return s.listener() == func);
    }
}

class PrioritySlot3<T1, T2, T3> extends Slot3<T1, T2, T3> {

    private var _priority : Int;

    public function new(    signal : Signal3<T1, T2, T3>,
                            listener : PartialFunction3<T1, T2, T3, Void>,
                            once : Bool,
                            priority : Int) {
        super(signal, listener, once);

        _priority = priority;
    }

    inline public function priority() : Int return _priority;
}
