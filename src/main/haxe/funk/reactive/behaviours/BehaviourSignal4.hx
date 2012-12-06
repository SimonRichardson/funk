package funk.reactive.behaviours;

import funk.Funk;
import funk.reactive.Behaviour;
import funk.reactive.Propagation;
import funk.reactive.extensions.Propagations;
import funk.reactive.extensions.Streams;
import funk.signal.Signal4;
import funk.types.Tuple4;

class BehaviourSignal4 {

	public static function signal<T1, T2, T3, T4>( signal: Signal4<T1, T2, T3, T4>
                                                   ) : Behaviour<Tuple4<T1, T2, T3, T4>> {
        var behaviour = new Behaviour<Tuple4<T1, T2, T3, T4>>(  Streams.identity(None),
        						      					        tuple4(null, null, null, null),
        							     				        Propagations.identity());

        signal.add(function(value0 : T1, value1 : T2, value2 : T3, value3 : T4) {
            behaviour.emit(tuple4(value0, value1, value2, value3));
        });

        return behaviour;
    }
}
