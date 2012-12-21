package funk.signals.extensions;

import funk.Funk;
import funk.signals.Signal0;
import funk.signals.Signal1;
import funk.signals.Signal2;
import funk.signals.Signal3;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Function2;
import funk.types.Function3;
import funk.types.Predicate1;
import funk.types.Predicate2;
import funk.types.Predicate3;
import funk.types.Tuple2;
import funk.types.Tuple3;
import funk.types.extensions.Functions2;
import funk.types.extensions.Functions3;
import funk.types.extensions.Tuples3;

using funk.types.extensions.Functions2;
using funk.types.extensions.Functions3;
using funk.types.extensions.Tuples3;

class Signals3 {

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

        signal.add(function (value) {
            value.add(function (value0, value1, value2) {
                result.dispatch(value0, value1, value2);
            });
        });

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
                    Functions2.untuple(signal.dispatch)(func(aa.shift(), bb.shift()));
                }
            }

            a.add(function (value0, value1, value2) {
                Functions3.tuple(aa.push)(value0, value1, value2);
                check();
            });
            b.add(function (value0, value1, value2) {
                Functions3.tuple(bb.push)(value0, value1, value2);
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
            Functions3.untuple(result.dispatch)(func(value0, value1, value2));
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
