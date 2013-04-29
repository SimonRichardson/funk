package funk.signals;

import funk.Funk;

using funk.ds.immutable.List;
using funk.types.Function1;
using funk.types.Function2;
using funk.types.Function5;
using funk.types.Predicate5;
using funk.types.Option;
using funk.types.Tuple2;
using funk.types.Tuple5;

class Signal5<T1, T2, T3, T4, T5> {

    private var _list : List<Slot5<T1, T2, T3, T4, T5>>;

    public function new() {
        _list = Nil;
    }

    public function add(    func : Function5<T1, T2, T3, T4, T5, Void>
                            ) : Option<Slot5<T1, T2, T3, T4, T5>> {

        return registerListener(func, false);
    }

    public function addOnce(    func : Function5<T1, T2, T3, T4, T5, Void>
                                ) : Option<Slot5<T1, T2, T3, T4, T5>> {

        return registerListener(func, true);
    }

    public function remove(    func : Function5<T1, T2, T3, T4, T5, Void>
                            ) : Option<Slot5<T1, T2, T3, T4, T5>> {

        var o = _list.find(function(s : Slot5<T1, T2, T3, T4, T5>) : Bool {
            return Reflect.compareMethods(s.getListener(), func);
        });

        _list = _list.filterNot(function(s : Slot5<T1, T2, T3, T4, T5>) : Bool {
            return Reflect.compareMethods(s.getListener(), func);
        });

        return o;
    }

    public function removeAll() : Void {
        _list = Nil;
    }

    public function dispatch(    value0 : T1,
                                value1 : T2,
                                value2 : T3,
                                value3 : T4,
                                value4 : T5) : Void {
        var slots = _list;
        while(slots.nonEmpty()) {
            slots.head().execute(value0, value1, value2, value3, value4);
            slots = slots.tail();
          }
    }

    private function registerListener(    func : Function5<T1, T2, T3, T4, T5, Void>,
                                        once : Bool) : Option<Slot5<T1, T2, T3, T4, T5>> {

        if(registrationPossible(func, once)) {
            var slot : Slot5<T1, T2, T3, T4, T5> = new Slot5<T1, T2, T3, T4, T5>(this, func, once);
            _list = _list.prepend(slot);
            return Some(slot);
        }

        return _list.find(function(s : Slot5<T1, T2, T3, T4, T5>) : Bool {
            return Reflect.compareMethods(s.getListener(), func);
        });
    }

    private function registrationPossible(    func : Function5<T1, T2, T3, T4, T5, Void>,
                                            once : Bool) : Bool {
        if(!_list.nonEmpty()) {
            return true;
        }

        var slot = _list.find(function(s : Slot5<T1, T2, T3, T4, T5>) : Bool {
            return Reflect.compareMethods(s.getListener(), func);
        });

        return switch(slot) {
            case Some(x):
                if(x.getOnce() != once) {
                    Funk.error(IllegalOperationError('You cannot addOnce() then add() the same ' +
                     'listener without removing the relationship first.'));
                }
                false;
            case _: true;
        }
    }

    public function size() : Int {
        return _list.size();
    }
}

class Slot5<T1, T2, T3, T4, T5> {

    private var _listener : Function5<T1, T2, T3, T4, T5, Void>;

    private var _signal : Signal5<T1, T2, T3, T4, T5>;

    private var _once : Bool;

    public function new(    signal : Signal5<T1, T2, T3, T4, T5>,
                            listener : Function5<T1, T2, T3, T4, T5, Void>,
                            once : Bool) {
        _signal = signal;
        _listener = listener;
        _once = once;
    }

    public function execute(    value0 : T1,
                                value1 : T2,
                                value2 : T3,
                                value3 : T4,
                                value4 : T5) : Void {
        if(getOnce()) {
            remove();
        }

        var listener = getListener();
        listener(value0, value1, value2, value3, value4);
    }

    public function remove() : Void {
        _signal.remove(getListener());
    }

    public function getListener() : Function5<T1, T2, T3, T4, T5, Void> {
        return _listener;
    }

    public function getOnce() : Bool {
        return _once;
    }
}

class Signal5Types {

    public static function filter<T1, T2, T3, T4, T5>(  signal : Signal5<T1, T2, T3, T4, T5>,
                                                        func : Predicate5<T1, T2, T3, T4, T5>
                                                        ) : Signal5<T1, T2, T3, T4, T5> {
        var result = new Signal5<T1, T2, T3, T4, T5>();

        signal.add(function (value0, value1, value2, value3, value4) {
            if (func(value0, value1, value2, value3, value4)) {
                result.dispatch(value0, value1, value2, value3, value4);
            }
        });

        return result;
    }

    public static function flatMap<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(    signal : Signal5<T1, T2, T3, T4, T5>,
                                                                                func : Function5<T1, T2, T3, T4, T5,
                                                                                                    Signal5<T6, T7, T8, T9, T10>>
                                                                                ) : Signal5<T6, T7, T8, T9, T10> {
        var result = new Signal5<T6, T7, T8, T9, T10>();

        signal.add(function (value0, value1, value2, value3, value4) {
            func(value0, value1, value2, value3, value4).add(function (value5, value6, value7, value8, value9) {
                result.dispatch(value5, value6, value7, value8, value9);
            });
        });

        return result;
    }

    public static function flatten<T1, T2, T3, T4, T5>( signal : Signal1<Signal5<T1, T2, T3, T4, T5>>
                                                        ) : Signal5<T1, T2, T3, T4, T5> {
        var result = new Signal5<T1, T2, T3, T4, T5>();

        signal.add(function (value) {
            value.add(function (value0, value1, value2, value3, value4) {
                result.dispatch(value0, value1, value2, value3, value4);
            });
        });

        return result;
    }

    public static function lift<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, R1, R2>( func : Function2< Tuple5<T1, T2, T3, T4, T5>,
                                                                                                    Tuple5<T6, T7, T8, T9, T10>,
                                                                                                    Tuple2<R1, R2>>
                                                                                ) : Function2<  Signal5<T1, T2, T3, T4, T5>,
                                                                                                Signal5<T6, T7, T8, T9, T10>,
                                                                                                Signal2<R1, R2>> {
        return function (a : Signal5<T1, T2, T3, T4, T5>, b : Signal5<T6, T7, T8, T9, T10>) {
            var signal = new Signal2<R1, R2>();

            var aa = new Array<Tuple5<T1, T2, T3, T4, T5>>();
            var bb = new Array<Tuple5<T6, T7, T8, T9, T10>>();

            function check() {
                if (aa.length > 0 && bb.length > 0) {
                    Function2Types.untuple(signal.dispatch)(func(aa.shift(), bb.shift()));
                }
            }

            a.add(function (value0, value1, value2, value3, value4) {
                Function5Types.tuple(aa.push)(value0, value1, value2, value3, value4);
                check();
            });
            b.add(function (value0, value1, value2, value3, value4) {
                Function5Types.tuple(bb.push)(value0, value1, value2, value3, value4);
                check();
            });

            return signal;
        };
    }

    public static function map<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>( signal : Signal5<T1, T2, T3, T4, T5>,
                                                                         func : Function5<T1, T2, T3, T4, T5, Tuple5<T6, T7, T8, T9, T10>>
                                                                         ) : Signal5<T6, T7, T8, T9, T10> {
        var result = new Signal5<T6, T7, T8, T9, T10>();

        signal.add(function (value0, value1, value2, value3, value4) {
            Function5Types.untuple(result.dispatch)(func(value0, value1, value2, value3, value4));
        });

        return result;
    }

    public static function zip<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(    signal0 : Signal5<T1, T2, T3, T4, T5>,
                                                                            signal1 : Signal5<T6, T7, T8, T9, T10>
                                                                            ) : Signal2<    Tuple5<T1, T2, T3, T4, T5>,
                                                                                            Tuple5<T6, T7, T8, T9, T10>> {
        return lift(function (value0, value1) {
            return tuple2(value0, value1);
        })(signal0, signal1);
    }

    public static function zipWith<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, R1, R2>(    signal0 : Signal5<T1, T2, T3, T4, T5>,
                                                                                        signal1 : Signal5<T6, T7, T8, T9, T10>,
                                                                                        func : Function2<   Tuple5<T1, T2, T3, T4, T5>,
                                                                                                            Tuple5<T6, T7, T8, T9, T10>,
                                                                                                            Tuple2<R1, R2>>
                                                                                        ) : Signal2<R1, R2> {
        return lift(func)(signal0, signal1);
    }
}


