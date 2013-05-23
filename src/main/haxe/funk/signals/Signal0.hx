package funk.signals;

import funk.Funk;

using funk.ds.immutable.List;
using funk.types.Function0;
using funk.types.Function2;
using funk.types.PartialFunction1;
using funk.types.PartialFunction0;
using funk.types.Predicate0;
using funk.types.Option;
using funk.types.Tuple2;
using funk.types.Unit;

class Signal0 {

    private var _list : List<Slot0>;

    public function new() {
        _list = Nil;
    }

    public function add(func : PartialFunction0<Void>) : Option<Slot0> return registerListener(func, false);

    public function addOnce(func : PartialFunction0<Void>) : Option<Slot0> return registerListener(func, true);

    public function remove(func : PartialFunction0<Void>) : Option<Slot0> {
        var o = _list.find(function(s : Slot0) : Bool return s.listener() == func);
        _list = _list.filterNot(function(s : Slot0) : Bool return s.listener() == func);
        return o;
    }

    public function removeAll() : Void _list = Nil;

    public function dispatch() : Void {
        var slots = _list;
        while(slots.nonEmpty()) {
            slots.head().execute();
            slots = slots.tail();
        }
    }

    private function registerListener(func : PartialFunction0<Void>, once : Bool) : Option<Slot0> {
        if(registrationPossible(func, once)) {
            var slot : Slot0 = new Slot0(this, func, once);
            _list = _list.prepend(slot);
            return Some(slot);
        }

        return _list.find(function(s : Slot0) : Bool return Reflect.compareMethods(s.listener(), func));
    }

    private function registrationPossible(func : PartialFunction0<Void>, once : Bool) : Bool {
        if(!_list.nonEmpty()) return true;

        var slot = _list.find(function(s : Slot0) : Bool return s.listener() == func);
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

class Slot0 {

    private var _listener : PartialFunction0<Void>;

    private var _signal : Signal0;

    private var _once : Bool;

    public function new(signal : Signal0, listener : PartialFunction0<Void>, once : Bool) {
        _signal = signal;
        _listener = listener;
        _once = once;
    }

    public function execute() : Void {
        var l = listener();
        if (l.isDefinedAt()) {
            if(once()) remove();

            l.apply();
        }
    }

    inline public function remove() : Void _signal.remove(listener());

    inline public function listener() : PartialFunction0<Void> return _listener;

    inline public function once() : Bool return _once;
}

class Signal0Types {

    public static function filter(signal : Signal0, func : Predicate0) : Signal0 {
        var result = new Signal0();

        signal.add(function () {
            if (func()) result.dispatch();
        }.fromFunction());

        return result;
    }

    public static function flatMap(signal : Signal0, func : Function0<Signal0>) : Signal0 {
        var result = new Signal0();

        signal.add(function () {
            func().add(function () {
                result.dispatch();
            }.fromFunction());
        }.fromFunction());

        return result;
    }

    public static function lift(func : Function0<Unit>) : Function2<Signal0, Signal0, Signal0> {
        return function (a : Signal0, b : Signal0) {
            var signal = new Signal0();

            var aa = [];
            var bb = [];

            function check() {
                if (aa.length > 0 && bb.length > 0) {
                    aa.pop();
                    bb.pop();

                    func();
                    signal.dispatch();
                }
            }

            a.add(function () {
                aa.push(Unit);
                check();
            }.fromFunction());
            b.add(function () {
                bb.push(Unit);
                check();
            }.fromFunction());

            return signal;
        };
    }

    public static function zip(signal0 : Signal0, signal1 : Signal0) : Signal0 {
        return lift(function () return Unit)(signal0, signal1);
    }

    public static function zipWith(signal0 : Signal0, signal1 : Signal0, func : Function0<Unit>) : Signal0 {
        return lift(func)(signal0, signal1);
    }
}

