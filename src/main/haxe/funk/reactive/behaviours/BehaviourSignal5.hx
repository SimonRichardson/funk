package funk.reactive.behaviours;

import funk.Funk;
import funk.reactive.Behaviour;
import funk.reactive.Propagation;
import funk.reactive.extensions.Propagations;
import funk.reactive.extensions.Streams;
import funk.signal.Signal4;
import funk.types.Tuple4;

class BehaviourSignal5 {

	public static function signal<T1, T2, T3, T4, T5>( signal: Signal5<T1, T2, T3, T4, T5>
                                                       ) : Behaviour<Tuple5<T1, T2, T3, T4, T5>> {
        var behaviour = new Behaviour<Tuple5<T1, T2, T3, T4, T5>>( Streams.identity(None),
        						      					           tuple5(null, null, null, null, null),
        							     				           Propagations.identity());

        signal.add(function(value0 : T1, value1 : T2, value2 : T3, value3 : T4, value4 : T5) {
            behaviour.emit(tuple5(value0, value1, value2, value3, value4));
        });

        return behaviour;
    }
}
