package funk.reactive.signals;

import funk.Funk;
import funk.reactive.Propagation;
import funk.reactive.Signal;
import funk.signal.Signal0;

class SignalSignal0 {

	public static function stream(signal: Signal0) : Signal<Unit> {

        var stream = Streams.identity();
        var pulser = function(pulse : Pulse<Unit>) : Propagation<Unit> {
            return Propagate(pulse);
        }

        signal.add(function(){
            stream.emit(Unit);
        });

        return new Signal<Unit>(stream, Unit, pulser);
    }
}
