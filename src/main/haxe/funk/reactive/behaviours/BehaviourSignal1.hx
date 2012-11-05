package funk.reactive.behaviours;

import funk.Funk;
import funk.reactive.Behaviour;
import funk.reactive.Propagation;
import funk.reactive.Propagations;
import funk.signal.Signal1;
import funk.tuple.Tuple;
import funk.tuple.Tuple1;

using funk.tuple.Tuple;

class BehaviourSignal1 {

	public static function signal<T1>(signal: Signal1<T1>) : Behaviour<ITuple1<T1>> {
        var behaviour = new Behaviour<ITuple1<T1>>( Streams.identity(), 
                                                    Tuples.toTuple1(null), 
                                                    Propagations.identity());

        signal.add(function(value0 : T1) {
            behaviour.emit(Tuples.toTuple1(value0));
        });

        return behaviour;
    }
}
