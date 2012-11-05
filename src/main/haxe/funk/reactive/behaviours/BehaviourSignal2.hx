package funk.reactive.behaviours;

import funk.Funk;
import funk.reactive.Behaviour;
import funk.reactive.Propagation;
import funk.reactive.Propagations;
import funk.signal.Signal2;
import funk.tuple.Tuple;
import funk.tuple.Tuple2;

using funk.tuple.Tuple;

class BehaviourSignal2 {

	public static function signal<T1, T2>(signal: Signal2<T1, T2>) : Behaviour<ITuple2<T1, T2>> {
        var behaviour = new Behaviour<ITuple2<T1, T2>>( Streams.identity(),
        											    Tuples.toTuple2(null, null),
        											    Propagations.identity());

        signal.add(function(value0 : T1, value1 : T2) {
            behaviour.emit(Tuples.toTuple2(value0, value1));
        });

        return behaviour;
    }
}
