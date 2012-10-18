package funk.reactive;

import funk.collections.IterableUtil;
import funk.errors.IllegalOperationError;
import funk.reactive.Propagation;

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

}
