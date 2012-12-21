package funk.signals.extensions;

import funk.Funk;
import funk.signals.Signal0;
import funk.signals.Signal1;
import funk.signals.Signal2;
import funk.signals.Signal3;
import funk.signals.Signal4;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Function2;
import funk.types.Function3;
import funk.types.Function4;
import funk.types.Predicate1;
import funk.types.Predicate2;
import funk.types.Predicate3;
import funk.types.Predicate4;
import funk.types.Tuple2;
import funk.types.Tuple3;
import funk.types.Tuple4;
import funk.types.extensions.Functions2;
import funk.types.extensions.Functions3;
import funk.types.extensions.Functions4;
import funk.types.extensions.Tuples4;

using funk.types.extensions.Functions2;
using funk.types.extensions.Functions3;
using funk.types.extensions.Functions4;
using funk.types.extensions.Tuples4;

class Signals4 {

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
                    Functions2.untuple(signal.dispatch)(func(aa.shift(), bb.shift()));
                }
            }

            a.add(function (value0, value1, value2, value3) {
                Functions4.tuple(aa.push)(value0, value1, value2, value3);
                check();
            });
            b.add(function (value0, value1, value2, value3) {
                Functions4.tuple(bb.push)(value0, value1, value2, value3);
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
            Functions4.untuple(result.dispatch)(func(value0, value1, value2, value3));
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
