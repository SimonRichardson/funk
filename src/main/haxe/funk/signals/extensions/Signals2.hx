package funk.signals.extensions;

import funk.Funk;
import funk.signals.Signal0;
import funk.signals.Signal1;
import funk.signals.Signal2;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Function2;
import funk.types.Predicate1;
import funk.types.Predicate2;
import funk.types.Tuple2;
import funk.types.extensions.Functions2;
import funk.types.extensions.Tuples2;

using funk.types.extensions.Functions2;
using funk.types.extensions.Tuples2;

class Signals2 {

    public static function filter<T1, T2>(signal : Signal2<T1, T2>, func : Predicate2<T1, T2>) : Signal2<T1, T2> {
        var result = new Signal2<T1, T2>();

        signal.add(function (value0, value1) {
            if (func(value0, value1)) {
                result.dispatch(value0, value1);
            }
        });

        return result;
    }

    public static function flatMap<T1, T2, T3, T4>( signal : Signal2<T1, T2>,
                                                    func : Function2<T1, T2, Signal2<T3, T4>>
                                                    ) : Signal2<T3, T4> {
        var result = new Signal2<T3, T4>();

        signal.add(function (value0, value1) {
            func(value0, value1).add(function (value2, value3) {
                result.dispatch(value2, value3);
            });
        });

        return result;
    }

    public static function flatten<T1, T2>(signal : Signal1<Signal2<T1, T2>>) : Signal2<T1, T2> {
        var result = new Signal2<T1, T2>();

        signal.add(function (value) {
            value.add(function (value0, value1) {
                result.dispatch(value0, value1);
            });
        });

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
                    Functions2.untuple(signal.dispatch)(func(aa.shift(), bb.shift()));
                }
            }

            a.add(function (value0, value1) {
                Functions2.tuple(aa.push)(value0, value1);
                check();
            });
            b.add(function (value0, value1) {
                Functions2.tuple(bb.push)(value0, value1);
                check();
            });

            return signal;
        };
    }

    public static function map<T1, T2, T3, T4>( signal : Signal2<T1, T2>,
                                                func : Function2<T1, T2, Tuple2<T3, T4>>
                                                ) : Signal2<T3, T4> {
        var result = new Signal2<T3, T4>();

        signal.add(function (value0, value1) {
            Functions2.untuple(result.dispatch)(func(value0, value1));
        });

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
