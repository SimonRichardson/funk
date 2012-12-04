package funk.reactive.behaviours;

import funk.Funk;
import funk.reactive.Behaviour;
import funk.reactive.Propagation;
import funk.reactive.extensions.Propagations;
import funk.reactive.extensions.Streams;
import funk.signal.Signal0;
import funk.types.Tuple1;

class BehaviourSignal0 {

    public static function signal(signal: Signal0) : Behaviour<Tuple1<Unit>> {
        var behaviour = new Behaviour<Tuple1<Unit>>(	Streams.identity(), 
                                                        tuple1(null), 
                                                        Propagations.identity());
        signal.add(function() {
            behaviour.emit(tuple1(Unit));
        });
        return behaviour;
    }
}
