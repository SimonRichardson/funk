package funk.reactive.signals;

import funk.Funk;
import funk.reactive.Propagation;
import funk.reactive.Signal;
import funk.signal.Signal0;
import funk.tuple.Tuple;
import funk.tuple.Tuple1;

using funk.tuple.Tuple;

class SignalSignal0 {

    public static function signal(signal: Signal0) : Signal<ITuple1<Unit>> {

        var pulser = function(pulse : Pulse<ITuple1<Unit>>) : Propagation<ITuple1<Unit>> {
            return Propagate(pulse);
        };
        var react = new Signal<ITuple1<Unit>>(Streams.identity(), Tuples.toTuple1(null), pulser);

        signal.add(function() {
            react.emit(Tuples.toTuple1(Unit));
        });

        return react;
    }
}
