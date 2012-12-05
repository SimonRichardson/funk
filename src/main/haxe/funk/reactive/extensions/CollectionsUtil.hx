package funk.reactive.extensions;

import funk.collections.Collection;
import funk.Funk;
import funk.types.Function0;
import funk.types.Option;
import funk.reactive.Behaviour;
import funk.reactive.Process;
import funk.reactive.Stream;

class CollectionsUtil {

	public static function toStream<T>(collection: Collection<T>, time: Behaviour<Int>) : Stream<T> {
		var startTime = -1.0;
		var accumulation = 0;

		if(collection.size() < 1) {
			return Streams.zero();
		}

		var task : Option<Task> = None;
		var pulser : Function0<Void> = null;
		var stream : Stream<T> = Streams.identity(None);

		var iterator = collection.iterator();

		var create : Function0<Option<Task>> = function() {
			task = Process.stop(task);

			var nowTime = Process.stamp();

			if(startTime < 0) {
				startTime = nowTime;
			}

			var delta = time.value();
			var endTime = startTime + accumulation + delta;
			var timeToWait = endTime - nowTime;

			accumulation += delta;

			return if(timeToWait < 0) {
				pulser();
				None;
			} else {
				Process.start(pulser, timeToWait);
			}
		};

		pulser = function() {
			var next = iterator.next();

			stream.emit(next);

			task = Process.stop(task);

			if(iterator.hasNext()) {
				task = create();
			}
		};

		task = create();

		return stream;
	}
}
