package funk.reactive.streams;

import funk.collections.extensions.CollectionsUtil;
import funk.reactive.Propagation;
import funk.reactive.Pulse;
import funk.reactive.Stream;
import funk.reactive.extensions.Pulses;
import funk.reactive.extensions.Streams;
import haxe.ds.Option;

using funk.collections.extensions.CollectionsUtil;
using funk.reactive.extensions.Pulses;
using funk.reactive.extensions.Streams;

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
			time = pulse.time();
			value = pulse.value();

			return Negate;
		}, Some([stream].toCollection()));

		return Streams.create(function(pulse : Pulse<T>) : Propagation<T> {
			return if(value && (time == pulse.time())) {
				Propagate(pulse);
			} else {
				Negate;
			}
		}, Some([block].toCollection()));
	}

	public static function ifThenElse<T>(	stream : Stream<Bool>,
											thenBlock : Stream<T>,
											elseBlock : Stream<T>) : Stream<T> {
		var time = -1.0;
		var value = false;

		Streams.create(function(pulse : Pulse<Bool>) : Propagation<Bool> {
			time = pulse.time();
			value = pulse.value();

			return Negate;
		}, Some([stream].toCollection()));

		return Streams.merge([
			Streams.create(function(pulse : Pulse<T>) : Propagation<T> {
				return if(value && (time == pulse.time())) {
					Propagate(pulse);
				} else {
					Negate;
				}
			}, Some([thenBlock].toCollection())),
			Streams.create(function(pulse : Pulse<T>) : Propagation<T> {
				return if(!value && (time == pulse.time())) {
					Propagate(pulse);
				} else {
					Negate;
				}
			}, Some([elseBlock].toCollection()))].toCollection());
	}
}
