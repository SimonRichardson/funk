package funk.reactive.signals;

import funk.Funk;
import funk.reactive.Propagation;
import funk.reactive.Signal;
import funk.signal.Signal4;
import funk.tuple.Tuple;
import funk.tuple.Tuple4;

using funk.tuple.Tuple;

class SignalSignal4 {

	public static function signal<T1, T2, T3, T4>( signal: Signal4<T1, T2, T3, T4>
                                                ) : Signal<ITuple4<T1, T2, T3, T4>> {

        var pulser = function(  pulse : Pulse<ITuple4<T1, T2, T3, T4>>
                                ) : Propagation<ITuple4<T1, T2, T3, T4>> {
            return Propagate(pulse);
        };
        var react = new Signal<ITuple4<T1, T2, T3, T4>>(	Streams.identity(),
        						      					    Tuples.toTuple4(null, null, null, null),
        							     				    pulser);

        signal.add(function(value0 : T1, value1 : T2, value2 : T3, value3 : T4) {
            react.emit(Tuples.toTuple4(value0, value1, value2, value3));
        });

        return react;
    }
}
