package funk.reactive.signals;

import funk.Funk;
import funk.reactive.Propagation;
import funk.reactive.Signal;
import funk.signal.Signal1;
import funk.tuple.Tuple;
import funk.tuple.Tuple1;

using funk.tuple.Tuple;

class SignalSignal1 {

	public static function signal<T1>(signal: Signal1<T1>) : Signal<ITuple1<T1>> {

        var pulser = function(pulse : Pulse<ITuple1<T1>>) : Propagation<ITuple1<T1>> {
            return Propagate(pulse);
        };
        var react = new Signal<ITuple1<T1>>(Streams.identity(), Tuples.toTuple1(null), pulser);

        signal.add(function(value0 : T1) {
            react.emit(Tuples.toTuple1(value0));
        });

        return react;
    }
}
