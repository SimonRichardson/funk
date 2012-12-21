package funk.signals.extensions;

import funk.Funk;
import funk.signals.Signal0;
import funk.signals.Signal1;
import funk.signals.Signal2;
import funk.signals.Signal3;
import funk.signals.Signal4;
import funk.signals.Signal5;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Function2;
import funk.types.Function3;
import funk.types.Function4;
import funk.types.Function5;
import funk.types.Predicate1;
import funk.types.Predicate2;
import funk.types.Predicate3;
import funk.types.Predicate4;
import funk.types.Predicate5;
import funk.types.Tuple2;
import funk.types.Tuple3;
import funk.types.Tuple4;
import funk.types.Tuple4;
import funk.types.Tuple5;
import funk.types.extensions.Functions2;
import funk.types.extensions.Functions3;
import funk.types.extensions.Functions4;
import funk.types.extensions.Functions5;
import funk.types.extensions.Tuples5;

using funk.types.extensions.Functions2;
using funk.types.extensions.Functions3;
using funk.types.extensions.Functions4;
using funk.types.extensions.Tuples5;

class Signals5 {

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
                                                                                func : Function5<T1, T2, T3, T4, T5, Signal5<T6, T7, T8, T9, T10>>
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
                    Functions2.untuple(signal.dispatch)(func(aa.shift(), bb.shift()));
                }
            }

            a.add(function (value0, value1, value2, value3, value4) {
                Functions5.tuple(aa.push)(value0, value1, value2, value3, value4);
                check();
            });
            b.add(function (value0, value1, value2, value3, value4) {
                Functions5.tuple(bb.push)(value0, value1, value2, value3, value4);
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
            Functions5.untuple(result.dispatch)(func(value0, value1, value2, value3, value4));
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
