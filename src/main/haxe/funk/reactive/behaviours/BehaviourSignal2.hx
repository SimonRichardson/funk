package funk.reactive.behaviours;

import funk.Funk;
import funk.reactive.Behaviour;
import funk.reactive.Propagation;
import funk.reactive.extensions.Behaviours;
import funk.reactive.extensions.Propagations;
import funk.reactive.extensions.Streams;
import funk.signal.Signal2;
import funk.types.Tuple2;

using funk.reactive.extensions.Behaviours;

class BehaviourSignal2 {

	public static function signal<T1, T2>(signal: Signal2<T1, T2>) : Behaviour<Tuple2<T1, T2>> {
        var behaviour = new Behaviour<Tuple2<T1, T2>>( Streams.identity(None),
        											    tuple2(null, null),
        											    Propagations.identity());

        signal.add(function(value0 : T1, value1 : T2) {
            behaviour.emit(tuple2(value0, value1));
        });

        return behaviour;
    }
}
