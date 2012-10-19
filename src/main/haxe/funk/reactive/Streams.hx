package funk.reactive;

import funk.collections.IterableUtil;
import funk.errors.IllegalOperationError;
import funk.option.Option;
import funk.reactive.Propagation;
import funk.reactive.utils.Timer;

using funk.collections.IterableUtil;

class Streams {

	public static function create<T1, T2>(	pulse: Pulse<T1> -> Propagation<T2>,
										    sources: Iterable<Stream<T1>> = null
										    ) : Stream<T2> {
        var sourceEvents = sources == null ? null : sources.toArray();
        return new Stream<T2>(cast pulse, cast sourceEvents);
    }

	public static function identity<T>(sources: Iterable<Stream<T>> = null) : Stream<T> {
        var sourceArray = sources == null ? null : sources.toArray();
        return new Stream<T>(function(pulse) {
        		return Propagate(pulse);
        	}, sourceArray);
    }

    public static function zero<T>() : Stream<T> {
        return Streams.create(function(pulse : Pulse<T>) : Propagation<T> {
                throw new IllegalOperationError("Received a value that wasn't expected " + pulse.value);
                return Negate;
            });
    }

    public static function merge<T>(streams : Iterable<Stream<T>>) : Stream<T> {
        return if(streams.size() == 0) {
            zero();
        } else {
            identity(streams);
        };
    }

    public static function timer(time : Signal<Int>) : Stream<Int> {        
        var timer : Option<Timer> = None;
        var stream : Stream<Int> = identity();

        var finished : Bool = false;
        var pulser : Void -> Void = null;
        var createTimer : Void -> Option<Timer> = function() {
            return Some(Timer.delay(pulser, time.value));
        };
        var destroyTimer : Void -> Void = function() {
            switch(timer) {
                case Some(value):
                    value.stop();
                case None:
            }
        };

        stream.whenFinishedDo(function() {
            finished = true;
            destroyTimer();
        });

        pulser = function() {
            stream.emit(Std.int(Date.now().getTime()));
            destroyTimer();

            if(!finished) {
                timer = createTimer();
            }
        };

        timer = createTimer();    
        
        return stream;
    }

    public static function random(time : Signal<Int>) : Stream<Float> {
        var timerStream : Stream<Int> = timer(time);
        var mapStream : Stream<Float> = timerStream.map(function(value) {
            return Math.random();
        });
        mapStream.whenFinishedDo(function() : Void {
            timerStream.finish();
        });

        return mapStream;
    }

}
