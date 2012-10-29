package funk.reactive.signals;

import funk.Funk;
import funk.reactive.Propagation;
import funk.reactive.Signal;
import funk.signal.Signal3;
import funk.tuple.Tuple;
import funk.tuple.Tuple3;

using funk.tuple.Tuple;

class SignalSignal3 {

	public static function signal<T1, T2, T3>( signal: Signal3<T1, T2, T3>
                                                ) : Signal<ITuple3<T1, T2, T3>> {

        var pulser = function(  pulse : Pulse<ITuple3<T1, T2, T3>>
                                ) : Propagation<ITuple3<T1, T2, T3>> {
            return Propagate(pulse);
        };
        var react = new Signal<ITuple3<T1, T2, T3>>(	Streams.identity(),
        						      					Tuples.toTuple3(null, null, null),
        							     				pulser);

        signal.add(function(value0 : T1, value1 : T2, value2 : T3) {
            react.emit(Tuples.toTuple3(value0, value1, value2));
        });

        return react;
    }
}
