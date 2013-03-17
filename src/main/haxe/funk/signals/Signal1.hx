package funk.signals;

import funk.Funk;

using funk.collections.immutable.List;
using funk.types.Function1;
using funk.types.Function2;
using funk.types.Predicate1;
using funk.types.Option;
using funk.types.Tuple2;

class Signal1<T1> {

    private var _list : List<Slot1<T1>>;

    public function new() {
        _list = Nil;
    }

    public function add(func : Function1<T1, Void>) : Option<Slot1<T1>> {
        return registerListener(func, false);
    }

    public function addOnce(func : Function1<T1, Void>) : Option<Slot1<T1>> {
        return registerListener(func, true);
    }

    public function remove(func : Function1<T1, Void>) : Option<Slot1<T1>> {
        var o = _list.find(function(s : Slot1<T1>) : Bool {
            return Reflect.compareMethods(s.getListener(), func);
        });

        _list = _list.filterNot(function(s : Slot1<T1>) : Bool {
            return Reflect.compareMethods(s.getListener(), func);
        });

        return o;
    }

    public function removeAll() : Void {
        _list = Nil;
    }

    public function dispatch(value0 : T1) : Void {
        var slots = _list;
        while(slots.nonEmpty()) {
            slots.head().execute(value0);
            slots = slots.tail();
          }
    }

    private function registerListener(    func : Function1<T1, Void>,
                                        once : Bool) : Option<Slot1<T1>> {

        if(registrationPossible(func, once)) {
            var slot : Slot1<T1> = new Slot1<T1>(this, func, once);
            _list = _list.prepend(slot);
            return Some(slot);
        }

        return _list.find(function(s : Slot1<T1>) : Bool {
            return Reflect.compareMethods(s.getListener(), func);
        });
    }

    private function registrationPossible(func : Function1<T1, Void>, once : Bool) : Bool {
        if(!_list.nonEmpty()) {
            return true;
        }

        var slot = _list.find(function(s : Slot1<T1>) : Bool {
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

class Slot1<T1> {

    private var _listener : Function1<T1, Void>;

    private var _signal : Signal1<T1>;

    private var _once : Bool;

    public function new(signal : Signal1<T1>, listener : Function1<T1, Void>, once : Bool) {
        _signal = signal;
        _listener = listener;
        _once = once;
    }

    public function execute(value0 : T1) : Void {
        if(getOnce()) {
            remove();
        }

        var listener = getListener();
        listener(value0);
    }

    public function remove() : Void {
        _signal.remove(getListener());
    }

    public function getListener() : Function1<T1, Void> {
        return _listener;
    }

    public function getOnce() : Bool {
        return _once;
    }
}

class Signal1Types {

    public static function filter<T>(signal : Signal1<T>, func : Predicate1<T>) : Signal1<T> {
        var result = new Signal1<T>();

        signal.add(function (value0) {
            if (func(value0)) {
                result.dispatch(value0);
            }
        });

        return result;
    }

    public static function flatMap<T1, T2>(signal : Signal1<T1>, func : Function1<T1, Signal1<T2>>) : Signal1<T2> {
        var result = new Signal1<T2>();

        signal.add(function (value0) {
            func(value0).add(function (value1) {
                result.dispatch(value1);
            });
        });

        return result;
    }

    public static function flatten<T>(signal : Signal1<Signal1<T>>) : Signal1<T> {
        var result = new Signal1<T>();

        signal.add(function (value) {
            value.add(function (value) {
                result.dispatch(value);
            });
        });

        return result;
    }

    public static function lift<T1, T2, R>( func : Function2<T1, T2, R>
                                            ) : Function2<Signal1<T1>, Signal1<T2>, Signal1<R>> {
        return function (a : Signal1<T1>, b : Signal1<T2>) {
            var signal = new Signal1<R>();

            var aa = [];
            var bb = [];

            function check() {
                if (aa.length > 0 && bb.length > 0) {
                    signal.dispatch(func(aa.shift(), bb.shift()));
                }
            }

            a.add(function (value) {
                aa.push(value);
                check();
            });
            b.add(function (value) {
                bb.push(value);
                check();
            });

            return signal;
        };
    }

    public static function map<T1, T2>(signal : Signal1<T1>, func : Function1<T1, T2>) : Signal1<T2> {
        var result = new Signal1<T2>();

        signal.add(function (value) {
            result.dispatch(func(value));
        });

        return result;
    }

    public static function zip<T1, T2>(signal0 : Signal1<T1>, signal1 : Signal1<T2>) : Signal1<Tuple2<T1, T2>> {
        return lift(function(value0, value1) {
            var tuple : Tuple2<T1, T2> = tuple2(value0, value1);
            return tuple;
        })(signal0, signal1);
    }

    public static function zipWith<T1, T2, R>(  signal0 : Signal1<T1>,
                                                signal1 : Signal1<T2>,
                                                func : Function2<T1, T2, R>
                                                ) : Signal1<R> {
        return lift(func)(signal0, signal1);
    }
}

