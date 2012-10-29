package funk.reactive;

import funk.Funk;
import funk.collections.IterableUtil;
import funk.errors.IllegalOperationError;
import funk.option.Option;
import funk.reactive.Propagation;
import funk.reactive.Process;

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

    public static function bind<T, E>(func : T -> Void, stream : Stream<E>) : Stream<E> {
        stream.forEach(function(v) {
            func(cast v);
        });
        return stream;
    }

    public static function timer(time : Signal<Int>) : Stream<Int> {
        var stream : Stream<Int> = identity();
        var task : Option<Task> = None;

        stream.whenFinishedDo(function() {
            task = Process.stop(task);
        });

        var pulser : Void -> Void = null;
        pulser = function() {
            stream.emit(Std.int(Process.stamp()));
            
            task = Process.stop(task);

            if(!stream.weakRef) {
                task = Process.start(pulser, time.value);
            }
        };

        task = Process.start(pulser, time.value);

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
