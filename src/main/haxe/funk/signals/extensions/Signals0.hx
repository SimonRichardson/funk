package funk.signals.extensions;

import funk.Funk;
import funk.signals.Signal0;
import funk.types.Function0;
import funk.types.Function2;
import funk.types.Predicate0;
import funk.types.Predicate1;

class Signals0 {

    public static function filter(signal : Signal0, func : Predicate0) : Signal0 {
        var result = new Signal0();

        signal.add(function () {
            if (func()) {
                result.dispatch();
            }
        });

        return result;
    }

    public static function flatMap(signal : Signal0, func : Function0<Signal0>) : Signal0 {
        var result = new Signal0();

        signal.add(function () {
            func().add(function () {
                result.dispatch();
            });
        });

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
            });
            b.add(function () {
                bb.push(Unit);
                check();
            });

            return signal;
        };
    }

    public static function zip(signal0 : Signal0, signal1 : Signal0) : Signal0 {
        return lift(function () {
            return Unit;
        })(signal0, signal1);
    }

    public static function zipWith(signal0 : Signal0, signal1 : Signal0, func : Function0<Unit>) : Signal0 {
        return lift(func)(signal0, signal1);
    }
}
