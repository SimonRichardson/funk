package funk.signals;

import funk.Funk;

using funk.collections.immutable.List;
using funk.types.Function1;
using funk.types.Function2;
using funk.types.Function4;
using funk.types.Predicate4;
using funk.types.Option;
using funk.types.Tuple2;
using funk.types.Tuple4;

class Signal4<T1, T2, T3, T4> {

    private var _list : List<Slot4<T1, T2, T3, T4>>;

    public function new() {
        _list = Nil;
    }

    public function add(func : Function4<T1, T2, T3, T4, Void>) : Option<Slot4<T1, T2, T3, T4>> {
        return registerListener(func, false);
    }

    public function addOnce(    func : Function4<T1, T2, T3, T4, Void>
                                ) : Option<Slot4<T1, T2, T3, T4>> {

        return registerListener(func, true);
    }

    public function remove(    func : Function4<T1, T2, T3, T4, Void>
                            ) : Option<Slot4<T1, T2, T3, T4>> {

        var o = _list.find(function(s : Slot4<T1, T2, T3, T4>) : Bool {
            return Reflect.compareMethods(s.getListener(), func);
        });

        _list = _list.filterNot(function(s : Slot4<T1, T2, T3, T4>) : Bool {
            return Reflect.compareMethods(s.getListener(), func);
        });

        return o;
    }

    public function removeAll() : Void {
        _list = Nil;
    }

    public function dispatch(value0 : T1, value1 : T2, value2 : T3, value3 : T4) : Void {
        var slots = _list;
        while(slots.nonEmpty()) {
            slots.head().execute(value0, value1, value2, value3);
            slots = slots.tail();
          }
    }

    private function registerListener(    func : Function4<T1, T2, T3, T4, Void>,
                                        once : Bool) : Option<Slot4<T1, T2, T3, T4>> {

        if(registrationPossible(func, once)) {
            var slot : Slot4<T1, T2, T3, T4> = new Slot4<T1, T2, T3, T4>(this, func, once);
            _list = _list.prepend(slot);
            return Some(slot);
        }

        return _list.find(function(s : Slot4<T1, T2, T3, T4>) : Bool {
            return Reflect.compareMethods(s.getListener(), func);
        });
    }

    private function registrationPossible(    func : Function4<T1, T2, T3, T4, Void>,
                                            once : Bool) : Bool {
        if(!_list.nonEmpty()) {
            return true;
        }

        var slot = _list.find(function(s : Slot4<T1, T2, T3, T4>) : Bool {
            return Reflect.compareMethods(s.getListener(), func);
        });

        return switch(slot) {
            case Some(x):
                if(x.getOnce() != once) {
                    Funk.error(IllegalOperationError('You cannot addOnce() then add() the same " +
                     "listener without removing the relationship first.'));
                }
                false;
            case _: true;
        }
    }

    public function size() : Int {
        return _list.size();
    }
}

class Slot4<T1, T2, T3, T4> {

    private var _listener : Function4<T1, T2, T3, T4, Void>;

    private var _signal : Signal4<T1, T2, T3, T4>;

    private var _once : Bool;

    public function new(    signal : Signal4<T1, T2, T3, T4>,
                            listener : Function4<T1, T2, T3, T4, Void>,
                            once : Bool) {
        _signal = signal;
        _listener = listener;
        _once = once;
    }

    public function execute(value0 : T1, value1 : T2, value2 : T3, value3 : T4) : Void {
        if(getOnce()) {
            remove();
        }

        var listener = getListener();
        listener(value0, value1, value2, value3);
    }

    public function remove() : Void {
        _signal.remove(getListener());
    }

    public function getListener() : Function4<T1, T2, T3, T4, Void> {
        return _listener;
    }

    public function getOnce() : Bool {
        return _once;
    }
}

class Signal4Types {

    public static function filter<T1, T2, T3, T4>(  signal : Signal4<T1, T2, T3, T4>,
                                                    func : Predicate4<T1, T2, T3, T4>
                                                    ) : Signal4<T1, T2, T3, T4> {
        var result = new Signal4<T1, T2, T3, T4>();

        signal.add(function (value0, value1, value2, value3) {
            if (func(value0, value1, value2, value3)) {
                result.dispatch(value0, value1, value2, value3);
            }
        });

        return result;
    }

    public static function flatMap<T1, T2, T3, T4, T5, T6, T7, T8>( signal : Signal4<T1, T2, T3, T4>,
                                                                    func : Function4<T1, T2, T3, T4, Signal4<T5, T6, T7, T8>>
                                                                    ) : Signal4<T5, T6, T7, T8> {
        var result = new Signal4<T5, T6, T7, T8>();

        signal.add(function (value0, value1, value2, value3) {
            func(value0, value1, value2, value3).add(function (value4, value5, value6, value7) {
                result.dispatch(value4, value5, value6, value7);
            });
        });

        return result;
    }

    public static function flatten<T1, T2, T3, T4>( signal : Signal1<Signal4<T1, T2, T3, T4>>
                                                    ) : Signal4<T1, T2, T3, T4> {
        var result = new Signal4<T1, T2, T3, T4>();

        signal.add(function (value) {
            value.add(function (value0, value1, value2, value3) {
                result.dispatch(value0, value1, value2, value3);
            });
        });

        return result;
    }

    public static function lift<T1, T2, T3, T4, T5, T6, T7, T8, R1, R2>( func : Function2<  Tuple4<T1, T2, T3, T4>,
                                                                                            Tuple4<T5, T6, T7, T8>,
                                                                                            Tuple2<R1, R2>>
                                                                                ) : Function2<  Signal4<T1, T2, T3, T4>,
                                                                                                Signal4<T5, T6, T7, T8>,
                                                                                                Signal2<R1, R2>> {
        return function (a : Signal4<T1, T2, T3, T4>, b : Signal4<T5, T6, T7, T8>) {
            var signal = new Signal2<R1, R2>();

            var aa = new Array<Tuple4<T1, T2, T3, T4>>();
            var bb = new Array<Tuple4<T5, T6, T7, T8>>();

            function check() {
                if (aa.length > 0 && bb.length > 0) {
                    Function2Types.untuple(signal.dispatch)(func(aa.shift(), bb.shift()));
                }
            }

            a.add(function (value0, value1, value2, value3) {
                Function4Types.tuple(aa.push)(value0, value1, value2, value3);
                check();
            });
            b.add(function (value0, value1, value2, value3) {
                Function4Types.tuple(bb.push)(value0, value1, value2, value3);
                check();
            });

            return signal;
        };
    }

    public static function map<T1, T2, T3, T4, T5, T6, T7, T8>( signal : Signal4<T1, T2, T3, T4>,
                                                                func : Function4<T1, T2, T3, T4, Tuple4<T5, T6, T7, T8>>
                                                                ) : Signal4<T5, T6, T7, T8> {
        var result = new Signal4<T5, T6, T7, T8>();

        signal.add(function (value0, value1, value2, value3) {
            Function4Types.untuple(result.dispatch)(func(value0, value1, value2, value3));
        });

        return result;
    }

    public static function zip<T1, T2, T3, T4, T5, T6, T7, T8>( signal0 : Signal4<T1, T2, T3, T4>,
                                                                signal1 : Signal4<T5, T6, T7, T8>
                                                                ) : Signal2<    Tuple4<T1, T2, T3, T4>,
                                                                                Tuple4<T5, T6, T7, T8>> {
        return lift(function (value0, value1) {
            return tuple2(value0, value1);
        })(signal0, signal1);
    }

    public static function zipWith<T1, T2, T3, T4, T5, T6, T7, T8, R1, R2>( signal0 : Signal4<T1, T2, T3, T4>,
                                                                            signal1 : Signal4<T5, T6, T7, T8>,
                                                                            func : Function2<   Tuple4<T1, T2, T3, T4>,
                                                                                                Tuple4<T5, T6, T7, T8>,
                                                                                                Tuple2<R1, R2>>
                                                                            ) : Signal2<R1, R2> {
        return lift(func)(signal0, signal1);
    }
}
