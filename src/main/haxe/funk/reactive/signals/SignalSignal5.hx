package funk.reactive.signals;

import funk.Funk;
import funk.reactive.Propagation;
import funk.reactive.Signal;
import funk.signal.Signal5;
import funk.tuple.Tuple;
import funk.tuple.Tuple5;

using funk.tuple.Tuple;

class SignalSignal5 {

	public static function signal<T1, T2, T3, T4, T5>( signal: Signal5<T1, T2, T3, T4, T5>
                                                       ) : Signal<ITuple5<T1, T2, T3, T4, T5>> {

        var pulser = function(  pulse : Pulse<ITuple5<T1, T2, T3, T4, T5>>
                                ) : Propagation<ITuple5<T1, T2, T3, T4, T5>> {
            return Propagate(pulse);
        };
        var react = new Signal<ITuple5<T1, T2, T3, T4, T5>>(  Streams.identity(),
        						      					      Tuples.toTuple5(null, null, null, null, null),
        							     				      pulser);

        signal.add(function(value0 : T1, value1 : T2, value2 : T3, value3 : T4, value4 : T5) {
            react.emit(Tuples.toTuple5(value0, value1, value2, value3, value4));
        });

        return react;
    }
}
