package funk.reactive.signals;

import funk.Funk;
import funk.reactive.Propagation;
import funk.reactive.Signal;
import funk.signal.Signal2;
import funk.tuple.Tuple;
import funk.tuple.Tuple2;

using funk.tuple.Tuple;

class SignalSignal2 {

	public static function signal<T1, T2>(signal: Signal2<T1, T2>) : Signal<ITuple2<T1, T2>> {

        var pulser = function(pulse : Pulse<ITuple2<T1, T2>>) : Propagation<ITuple2<T1, T2>> {
            return Propagate(pulse);
        };
        var react = new Signal<ITuple2<T1, T2>>(	Streams.identity(),
        											Tuples.toTuple2(null, null),
        											pulser);

        signal.add(function(value0 : T1, value1 : T2) {
            react.emit(Tuples.toTuple2(value0, value1));
        });

        return react;
    }
}
