package funk.signals;

import funk.Funk;

using funk.signals.Signal4;
using funk.types.Function4;
using funk.types.PartialFunction4;
using funk.types.Option;
using funk.ds.immutable.List;

class PrioritySignal4<T1, T2, T3, T4> extends Signal4<T1, T2, T3, T4> {

    public function new() {
        super();
    }

    public function addWithPriority(    func : PartialFunction4<T1, T2, T3, T4, Void>,
                                        ?priority : Int = 0) : Option<Slot4<T1, T2, T3, T4>> {
        return registerListenerWithPriority(func, false, priority);
    }

    public function addOnceWithPriority(    func : PartialFunction4<T1, T2, T3, T4, Void>,
                                            ?priority:Int = 0) : Option<Slot4<T1, T2, T3, T4>> {
        return registerListenerWithPriority(func, true, priority);
    }

    private function registerListenerWithPriority(  func : PartialFunction4<T1, T2, T3, T4, Void>,
                                                    once : Bool,
                                                    priority : Int
                                                    ) : Option<Slot4<T1, T2, T3, T4>> {
        if(registrationPossible(func, once)) {
            var added : Bool = false;
            var slot : Slot4<T1, T2, T3, T4> = new PrioritySlot4<T1, T2, T3, T4>(    this,
                                                                            func,
                                                                            once,
                                                                            priority);

            _list = _list.flatMap(function(value : Slot4<T1, T2, T3, T4>) {
                var prioritySlot : PrioritySlot4<T1, T2, T3, T4> = cast value;

                var list = Nil.prepend(value);
                return if(priority >= prioritySlot.priority()) {
                    added = true;
                    list.append(slot);
                } else list;
            });

            if(!added) _list = _list.prepend(slot);

            return Some(slot);
        }

        return _list.find(function(s : Slot4<T1, T2, T3, T4>) : Bool return s.listener() == func);
    }
}

class PrioritySlot4<T1, T2, T3, T4> extends Slot4<T1, T2, T3, T4> {

    private var _priority : Int;

    public function new(    signal : Signal4<T1, T2, T3, T4>,
                            listener : PartialFunction4<T1, T2, T3, T4, Void>,
                            once : Bool,
                            priority : Int) {
        super(signal, listener, once);

        _priority = priority;
    }

    inline public function priority() : Int return _priority;
}
