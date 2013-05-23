package funk.signals;

import funk.Funk;

using funk.ds.immutable.List;
using funk.types.Function1;
using funk.types.Function2;
using funk.types.Predicate2;
using funk.types.PartialFunction1;
using funk.types.PartialFunction2;
using funk.types.Option;
using funk.types.Tuple2;

class Signal2<T1, T2> {

    private var _list : List<Slot2<T1, T2>>;

    public function new() {
        _list = Nil;
    }

    public function add(func : PartialFunction2<T1, T2, Void>) : Option<Slot2<T1, T2>> {
        return registerListener(func, false);
    }

    public function addOnce(func : PartialFunction2<T1, T2, Void>) : Option<Slot2<T1, T2>> {
        return registerListener(func, true);
    }

    public function remove(func : PartialFunction2<T1, T2, Void>) : Option<Slot2<T1, T2>> {
        var o = _list.find(function(s : Slot2<T1, T2>) : Bool return s.listener() == func);
        _list = _list.filterNot(function(s : Slot2<T1, T2>) : Bool return s.listener() == func);
        return o;
    }

    public function removeAll() : Void _list = Nil;
    
    public function dispatch(value0 : T1, value1 : T2) : Void {
        var slots = _list;
        while(slots.nonEmpty()) {
            slots.head().execute(value0, value1);
            slots = slots.tail();
        }
    }

    private function registerListener(  func : PartialFunction2<T1, T2, Void>,
                                        once : Bool) : Option<Slot2<T1, T2>> {

        if(registrationPossible(func, once)) {
            var slot : Slot2<T1, T2> = new Slot2<T1, T2>(this, func, once);
            _list = _list.prepend(slot);
            return Some(slot);
        }

        return _list.find(function(s : Slot2<T1, T2>) : Bool return s.listener() == func);
    }

    private function registrationPossible(func : PartialFunction2<T1, T2, Void>, once : Bool) : Bool {
        if(!_list.nonEmpty()) return true;

        var slot = _list.find(function(s : Slot2<T1, T2>) : Bool return s.listener() == func);
        return switch(slot) {
            case Some(x):
                if(x.once() != once) {
                    Funk.error(IllegalOperationError('You cannot addOnce() then add() the same ' +
                     'listener without removing the relationship first.'));
                }
                false;
            case _: true;
        }
    }

    inline public function size() : Int return _list.size();
}

class Slot2<T1, T2> {

    private var _listener : PartialFunction2<T1, T2, Void>;

    private var _signal : Signal2<T1, T2>;

    private var _once : Bool;

    public function new(    signal : Signal2<T1, T2>,
                            listener : PartialFunction2<T1, T2, Void>,
                            once : Bool) {
        _signal = signal;
        _listener = listener;
        _once = once;
    }

    public function execute(value0 : T1, value1 : T2) : Void {
        var l = listener();
        if (l.isDefinedAt(value0, value1)) {
            if(once()) {
                remove();
            }

            l.apply(value0, value1);
        }
    }

    inline public function remove() : Void _signal.remove(listener());

    inline public function listener() : PartialFunction2<T1, T2, Void> return _listener;

    inline public function once() : Bool return _once;
}

class Signal2Types {

    public static function filter<T1, T2>(signal : Signal2<T1, T2>, func : Predicate2<T1, T2>) : Signal2<T1, T2> {
        var result = new Signal2<T1, T2>();

        signal.add(function (value0, value1) {
            if (func(value0, value1)) {
                result.dispatch(value0, value1);
            }
        }.fromFunction());

        return result;
    }

    public static function flatMap<T1, T2, T3, T4>( signal : Signal2<T1, T2>,
                                                    func : Function2<T1, T2, Signal2<T3, T4>>
                                                    ) : Signal2<T3, T4> {
        var result = new Signal2<T3, T4>();

        signal.add(function (value0, value1) {
            func(value0, value1).add(function (value2, value3) {
                result.dispatch(value2, value3);
            }.fromFunction());
        }.fromFunction());

        return result;
    }

    public static function flatten<T1, T2>(signal : Signal1<Signal2<T1, T2>>) : Signal2<T1, T2> {
        var result = new Signal2<T1, T2>();

        signal.add(function (value : Signal2<T1, T2>) {
            value.add(function (value0, value1) {
                result.dispatch(value0, value1);
            }.fromFunction());
        }.fromFunction());

        return result;
    }

    public static function lift<T1, T2, T3, T4, R1, R2>( func : Function2<  Tuple2<T1, T2>,
                                                                            Tuple2<T3, T4>,
                                                                            Tuple2<R1, R2>>
                                            ) : Function2<  Signal2<T1, T2>,
                                                            Signal2<T3, T4>,
                                                            Signal2<R1, R2>> {
        return function (a : Signal2<T1, T2>, b : Signal2<T3, T4>) {
            var signal = new Signal2<R1, R2>();

            var aa = new Array<Tuple2<T1, T2>>();
            var bb = new Array<Tuple2<T3, T4>>();

            function check() {
                if (aa.length > 0 && bb.length > 0) {
                    Function2Types.untuple(signal.dispatch)(func(aa.shift(), bb.shift()));
                }
            }

            a.add(function (value0, value1) {
                Function2Types.tuple(aa.push)(value0, value1);
                check();
            }.fromFunction());
            b.add(function (value0, value1) {
                Function2Types.tuple(bb.push)(value0, value1);
                check();
            }.fromFunction());

            return signal;
        };
    }

    public static function map<T1, T2, T3, T4>( signal : Signal2<T1, T2>,
                                                func : Function2<T1, T2, Tuple2<T3, T4>>
                                                ) : Signal2<T3, T4> {
        var result = new Signal2<T3, T4>();

        signal.add(function (value0, value1) {
            Function2Types.untuple(result.dispatch)(func(value0, value1));
        }.fromFunction());

        return result;
    }

    public static function zip<T1, T2, T3, T4>( signal0 : Signal2<T1, T2>,
                                                signal1 : Signal2<T3, T4>
                                                ) : Signal2<Tuple2<T1, T2>, Tuple2<T3, T4>> {
        return lift(function (value0, value1) {
            return tuple2(value0, value1);
        })(signal0, signal1);
    }

    public static function zipWith<T1, T2, T3, T4, R1, R2>( signal0 : Signal2<T1, T2>,
                                                            signal1 : Signal2<T3, T4>,
                                                            func : Function2<   Tuple2<T1, T2>,
                                                                                Tuple2<T3, T4>,
                                                                                Tuple2<R1, R2>>
                                                            ) : Signal2<R1, R2> {
        return lift(func)(signal0, signal1);
    }
}
