package funk.signals;

import funk.Funk;

using funk.ds.immutable.List;
using funk.types.Function1;
using funk.types.Function2;
using funk.types.Function3;
using funk.types.Predicate3;
using funk.types.PartialFunction1;
using funk.types.Option;
using funk.types.Tuple2;
using funk.types.Tuple3;

class Signal3<T1, T2, T3> {

    private var _list : List<Slot3<T1, T2, T3>>;

    public function new() {
        _list = Nil;
    }

    public function add(func : Function3<T1, T2, T3, Void>) : Option<Slot3<T1, T2, T3>> {
        return registerListener(func, false);
    }

    public function addOnce(func : Function3<T1, T2, T3, Void>) : Option<Slot3<T1, T2, T3>> {
        return registerListener(func, true);
    }

    public function remove(func : Function3<T1, T2, T3, Void>) : Option<Slot3<T1, T2, T3>> {
        var o = _list.find(function(s : Slot3<T1, T2, T3>) : Bool {
            return Reflect.compareMethods(s.getListener(), func);
        });

        _list = _list.filterNot(function(s : Slot3<T1, T2, T3>) : Bool {
            return Reflect.compareMethods(s.getListener(), func);
        });

        return o;
    }

    public function removeAll() : Void {
        _list = Nil;
    }

    public function dispatch(value0 : T1, value1 : T2, value2 : T3) : Void {
        var slots = _list;
        while(slots.nonEmpty()) {
            slots.head().execute(value0, value1, value2);
            slots = slots.tail();
          }
    }

    private function registerListener(    func : Function3<T1, T2, T3, Void>,
                                        once : Bool) : Option<Slot3<T1, T2, T3>> {

        if(registrationPossible(func, once)) {
            var slot : Slot3<T1, T2, T3> = new Slot3<T1, T2, T3>(this, func, once);
            _list = _list.prepend(slot);
            return Some(slot);
        }

        return _list.find(function(s : Slot3<T1, T2, T3>) : Bool {
            return Reflect.compareMethods(s.getListener(), func);
        });
    }

    private function registrationPossible(func : Function3<T1, T2, T3, Void>, once : Bool) : Bool {
        if(!_list.nonEmpty()) {
            return true;
        }

        var slot = _list.find(function(s : Slot3<T1, T2, T3>) : Bool {
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

class Slot3<T1, T2, T3> {

    private var _listener : Function3<T1, T2, T3, Void>;

    private var _signal : Signal3<T1, T2, T3>;

    private var _once : Bool;

    public function new(    signal : Signal3<T1, T2, T3>,
                            listener : Function3<T1, T2, T3, Void>,
                            once : Bool) {
        _signal = signal;
        _listener = listener;
        _once = once;
    }

    public function execute(value0 : T1, value1 : T2, value2 : T3) : Void {
        if(getOnce()) {
            remove();
        }

        var listener = getListener();
        listener(value0, value1, value2);
    }

    public function remove() : Void {
        _signal.remove(getListener());
    }

    public function getListener() : Function3<T1, T2, T3, Void> {
        return _listener;
    }

    public function getOnce() : Bool {
        return _once;
    }
}

class Signal3Types {

    public static function filter<T1, T2, T3>(  signal : Signal3<T1, T2, T3>,
                                                func : Predicate3<T1, T2, T3>
                                                ) : Signal3<T1, T2, T3> {
        var result = new Signal3<T1, T2, T3>();

        signal.add(function (value0, value1, value2) {
            if (func(value0, value1, value2)) {
                result.dispatch(value0, value1, value2);
            }
        });

        return result;
    }

    public static function flatMap<T1, T2, T3, T4, T5, T6>( signal : Signal3<T1, T2, T3>,
                                                            func : Function3<T1, T2, T3, Signal3<T4, T5, T6>>
                                                            ) : Signal3<T4, T5, T6> {
        var result = new Signal3<T4, T5, T6>();

        signal.add(function (value0, value1, value2) {
            func(value0, value1, value2).add(function (value3, value4, value5) {
                result.dispatch(value3, value4, value5);
            });
        });

        return result;
    }

    public static function flatten<T1, T2, T3>(signal : Signal1<Signal3<T1, T2, T3>>) : Signal3<T1, T2, T3> {
        var result = new Signal3<T1, T2, T3>();

        signal.add(function (value : Signal3<T1, T2, T3>) {
            value.add(function (value0, value1, value2) {
                result.dispatch(value0, value1, value2);
            });
        }.fromFunction());

        return result;
    }

    public static function lift<T1, T2, T3, T4, T5, T6, R1, R2>( func : Function2<  Tuple3<T1, T2, T3>,
                                                                                    Tuple3<T4, T5, T6>,
                                                                                    Tuple2<R1, R2>>
                                                                                ) : Function2<  Signal3<T1, T2, T3>,
                                                                                                Signal3<T4, T5, T6>,
                                                                                                Signal2<R1, R2>> {
        return function (a : Signal3<T1, T2, T3>, b : Signal3<T4, T5, T6>) {
            var signal = new Signal2<R1, R2>();

            var aa = new Array<Tuple3<T1, T2, T3>>();
            var bb = new Array<Tuple3<T4, T5, T6>>();

            function check() {
                if (aa.length > 0 && bb.length > 0) {
                    Function2Types.untuple(signal.dispatch)(func(aa.shift(), bb.shift()));
                }
            }

            a.add(function (value0, value1, value2) {
                Function3Types.tuple(aa.push)(value0, value1, value2);
                check();
            });
            b.add(function (value0, value1, value2) {
                Function3Types.tuple(bb.push)(value0, value1, value2);
                check();
            });

            return signal;
        };
    }

    public static function map<T1, T2, T3, T4, T5, T6>( signal : Signal3<T1, T2, T3>,
                                                        func : Function3<T1, T2, T3, Tuple3<T4, T5, T6>>
                                                        ) : Signal3<T4, T5, T6> {
        var result = new Signal3<T4, T5, T6>();

        signal.add(function (value0, value1, value2) {
            Function3Types.untuple(result.dispatch)(func(value0, value1, value2));
        });

        return result;
    }

    public static function zip<T1, T2, T3, T4, T5, T6>( signal0 : Signal3<T1, T2, T3>,
                                                        signal1 : Signal3<T4, T5, T6>
                                                        ) : Signal2<Tuple3<T1, T2, T3>, Tuple3<T4, T5, T6>> {
        return lift(function (value0, value1) {
            return tuple2(value0, value1);
        })(signal0, signal1);
    }

    public static function zipWith<T1, T2, T3, T4, T5, T6, R1, R2>( signal0 : Signal3<T1, T2, T3>,
                                                                    signal1 : Signal3<T4, T5, T6>,
                                                                    func : Function2<   Tuple3<T1, T2, T3>,
                                                                                        Tuple3<T4, T5, T6>,
                                                                                        Tuple2<R1, R2>>
                                                                        ) : Signal2<R1, R2> {
        return lift(func)(signal0, signal1);
    }
}


