package funk.reactive.behaviours;

import funk.Funk;
import funk.reactive.Behaviour;
import funk.reactive.Propagation;
import funk.reactive.Propagations;
import funk.signal.Signal3;
import funk.tuple.Tuple;
import funk.tuple.Tuple3;

using funk.tuple.Tuple;

class BehaviourSignal3 {

	public static function signal<T1, T2, T3>( signal: Signal3<T1, T2, T3>
                                                ) : Behaviour<ITuple3<T1, T2, T3>> {
        var behaviour = new Behaviour<ITuple3<T1, T2, T3>>( Streams.identity(),
        						      					    Tuples.toTuple3(null, null, null),
        							     				    Propagations.identity());

        signal.add(function(value0 : T1, value1 : T2, value2 : T3) {
            behaviour.emit(Tuples.toTuple3(value0, value1, value2));
        });

        return behaviour;
    }
}
