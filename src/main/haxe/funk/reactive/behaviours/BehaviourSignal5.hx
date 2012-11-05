package funk.reactive.behaviours;

import funk.Funk;
import funk.reactive.Behaviour;
import funk.reactive.Propagation;
import funk.reactive.Propagations;
import funk.signal.Signal5;
import funk.tuple.Tuple;
import funk.tuple.Tuple5;

using funk.tuple.Tuple;

class BehaviourSignal5 {

	public static function signal<T1, T2, T3, T4, T5>( signal: Signal5<T1, T2, T3, T4, T5>
                                                       ) : Behaviour<ITuple5<T1, T2, T3, T4, T5>> {
        var behaviour = new Behaviour<ITuple5<T1, T2, T3, T4, T5>>( Streams.identity(),
        						      					            Tuples.toTuple5(null, null, null, null, null),
        							     				            Propagations.identity());

        signal.add(function(value0 : T1, value1 : T2, value2 : T3, value3 : T4, value4 : T5) {
            behaviour.emit(Tuples.toTuple5(value0, value1, value2, value3, value4));
        });

        return behaviour;
    }
}
