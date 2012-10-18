package funk.reactive;

import funk.option.Option;
import funk.reactive.utils.Timer;

class Collections {

	public static function toStream<T>(collection: Iterable<T>, time: Signal<Int>) : Stream<T> {
		var startTime = -1.0;
		var accumulation = 0;

		var iterator = collection.iterator();

		if(!iterator.hasNext()) {
			return Streams.zero();
		}

		var timer : Option<Timer> = None;
		var stream : Stream<T> = Streams.identity();

		var pulser : Void -> Void = null;
		var createTimer : Void -> Option<Timer> = function() {
			var nowTime = Date.now().getTime();

			if(startTime < 0.0) {
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
				Some(Timer.delay(pulser, Std.int(timeToWait)));
			}
		};

		pulser = function() {
			var next = iterator.next();

			stream.emit(next);

			switch(timer) {
				case Some(value):
					value.stop();
				case None:
			}

			if(iterator.hasNext()) {
				timer = createTimer();
			}
		};

		timer = createTimer();

		return stream;
	}

}
