package funk.reactive.behaviours;

import funk.Funk;
import funk.reactive.Behaviour;
import funk.reactive.Propagation;
import funk.reactive.extensions.Behaviours;
import funk.reactive.extensions.Propagations;
import funk.reactive.extensions.Streams;
import funk.signal.Signal1;
import funk.types.Tuple1;

using funk.reactive.extensions.Behaviours;

class BehaviourSignal1 {

	public static function signal<T1>(signal: Signal1<T1>) : Behaviour<Tuple1<T1>> {
        var behaviour = new Behaviour<Tuple1<T1>>( Streams.identity(None), 
                                                    tuple1(null), 
                                                    Propagations.identity());

        signal.add(function(value0 : T1) {
            behaviour.emit(tuple1(value0));
        });

        return behaviour;
    }
}
