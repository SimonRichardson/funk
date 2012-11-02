package funk.reactive;

import funk.option.Option;
import funk.reactive.Process;

class Collections {

	public static function toStream<T>(collection: Iterable<T>, time: Signal<Int>) : Stream<T> {
		var startTime = -1.0;
		var accumulation = 0;

		var iterator = collection.iterator();

		if(!iterator.hasNext()) {
			return Streams.zero();
		}

		var task : Option<Task> = None;
		var pulser : Void -> Void = null;
		var stream : Stream<T> = Streams.identity();

		var create : Void -> Option<Task> = function() {
			task = Process.stop(task);

			var nowTime = Process.stamp();

			if(startTime < 0) {
				startTime = nowTime;
			}

			var delta = time.value;
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
