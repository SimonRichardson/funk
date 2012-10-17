package funk.reactive;

import funk.collections.IterableUtil;
import funk.reactive.Propagation;

using funk.collections.IterableUtil;

class Streams {

	public static function create<T1, T2>(	pulse: Pulse<T1> -> Propagation<T2>,
										    sources: Iterable<Stream<T1>> = null
										    ): Stream<T2> {
        var sourceEvents = sources == null ? null : sources.toArray();
        return new Stream<T2>(cast pulse, cast sourceEvents);
    }

	public static function identity<T>(sources: Iterable<Stream<T>> = null): Stream<T> {
        var sourceArray = sources == null ? null : sources.toArray();
        return new Stream<T>(function(pulse) {
        		return Propagate(pulse);
        	}, sourceArray);
    }

}
