package funk.reactive.behaviours;

import funk.Funk;
import funk.reactive.Behaviour;
import funk.reactive.Propagation;
import funk.reactive.extensions.Behaviours;
import funk.reactive.extensions.Propagations;
import funk.reactive.extensions.Streams;
import funk.signals.Signal3;
import funk.types.Tuple3;

using funk.reactive.extensions.Behaviours;

class BehaviourSignal3 {

	public static function signal<T1, T2, T3>( signal: Signal3<T1, T2, T3>
                                               ) : Behaviour<Tuple3<T1, T2, T3>> {
        var behaviour = new Behaviour<Tuple3<T1, T2, T3>>( Streams.identity(None),
        						      					    tuple3(null, null, null),
        							     				    Propagations.identity());

        signal.add(function(value0 : T1, value1 : T2, value2 : T3) {
            behaviour.dispatch(tuple3(value0, value1, value2));
        });

        return behaviour;
    }
}
