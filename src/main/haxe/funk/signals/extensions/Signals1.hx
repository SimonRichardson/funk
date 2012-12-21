package funk.signals.extensions;

import funk.Funk;
import funk.signals.Signal0;
import funk.signals.Signal1;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Function2;
import funk.types.Predicate1;
import funk.types.Tuple2;

class Signals1 {

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
        return lift(function (value0, value1) {
            return tuple2(value0, value1);
        })(signal0, signal1);
    }

    public static function zipWith<T1, T2, R>(  signal0 : Signal1<T1>,
                                                signal1 : Signal1<T2>,
                                                func : Function2<T1, T2, R>
                                                ) : Signal1<R> {
        return lift(func)(signal0, signal1);
    }
}
