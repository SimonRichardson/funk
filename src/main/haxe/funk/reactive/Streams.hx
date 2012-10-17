package funk.reactive;

import funk.collections.IterableUtil;
import funk.reactive.Propagation;

using funk.collections.IterableUtil;

class Streams {

	public static function create<T>(	pulse: Pulse<T> -> Propagation<T>,
										sources: Iterable<Stream<T>> = null
										): Stream<T> {
        var sourceEvents = sources == null ? null : sources.toArray();
        return new Stream<T>(pulse, sourceEvents);
    }

	public static function identity<T>(sources: Iterable<Stream<T>> = null): Stream<T> {
        var sourceArray = sources == null ? null : sources.toArray();
        return new Stream<T>(function(pulse) {
        		return Propagate(pulse);
        	}, sourceArray);
    }

}
