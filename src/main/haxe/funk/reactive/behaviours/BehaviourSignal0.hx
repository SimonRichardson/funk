package funk.reactive.behaviours;

import funk.Funk;
import funk.reactive.Behaviour;
import funk.reactive.Propagation;
import funk.reactive.Propagations;
import funk.signal.Signal0;
import funk.tuple.Tuple;
import funk.tuple.Tuple1;

using funk.tuple.Tuple;

class BehaviourSignal0 {

    public static function signal(signal: Signal0) : Behaviour<ITuple1<Unit>> {
        var behaviour = new Behaviour<ITuple1<Unit>>(   Streams.identity(), 
                                                        Tuples.toTuple1(null), 
                                                        Propagations.identity());

        signal.add(function() {
            behaviour.emit(Tuples.toTuple1(Unit));
        });

        return behaviour;
    }
}
