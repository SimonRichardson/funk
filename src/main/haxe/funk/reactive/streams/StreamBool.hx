package funk.reactive.streams;

import funk.reactive.Propagation;
import funk.reactive.Pulse;
import funk.reactive.Stream;
import funk.reactive.Streams;

class StreamBool {

	public static function not(stream : Stream<Bool>) : Stream<Bool> {
		return stream.map(function(value) {
			return !value;
		});
	}

	public static function and(stream0 : Stream<Bool>, stream1 : Stream<Bool>) : Stream<Bool> {
		return stream0.zipWith(stream1, function(a : Bool, b : Bool){
			return a && b;
		});
	}

	public static function or(stream0 : Stream<Bool>, stream1 : Stream<Bool>) : Stream<Bool> {
		return stream0.zipWith(stream1, function(a : Bool, b : Bool){
			return a || b;
		});
	}

	public static function ifThen<T>(stream : Stream<Bool>, block : Stream<T>) : Stream<T> {
		var time = -1.0;
		var value = false;

		Streams.create(function(pulse : Pulse<Bool>) : Propagation<Bool> {
			time = pulse.time;
			value = pulse.value;

			return Negate;
		}, [stream]);

		return Streams.create(function(pulse : Pulse<T>) : Propagation<T> {
			return if(value && (time == pulse.time)) {
				Propagate(pulse);
			} else {
				Negate;
			}
		}, [block]);
	}

	public static function ifThenElse<T>(	stream : Stream<Bool>,
											thenBlock : Stream<T>,
											elseBlock : Stream<T>) : Stream<T> {
		var time = -1.0;
		var value = false;

		Streams.create(function(pulse : Pulse<Bool>) : Propagation<Bool> {
			time = pulse.time;
			value = pulse.value;

			return Negate;
		}, [stream]);

		return Streams.merge([
			Streams.create(function(pulse : Pulse<T>) : Propagation<T> {
				return if(value && (time == pulse.time)) {
					Propagate(pulse);
				} else {
					Negate;
				}
			}, [thenBlock]),
			Streams.create(function(pulse : Pulse<T>) : Propagation<T> {
				return if(!value && (time == pulse.time)) {
					Propagate(pulse);
				} else {
					Negate;
				}
			}, [elseBlock])]);

	}

}
