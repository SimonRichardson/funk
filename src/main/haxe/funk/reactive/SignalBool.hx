package funk.reactive;

class SignalBool {

	public static function not(stream : Stream<Bool>) : Stream<Bool> {
		return stream.map(function(value) {
			return !value;
		});
	}

	public static function ifThen(stream : Stream<Bool>, block : Stream<T>) : Stream<T> {
		var time = -1;
		var value = false;

		Streams.create(function(pulse : Pulse<Bool>) : Propagation<Bool> {
			time = pulse.time;
			value = pulse.value;
		}, [stream]);

		return Streams.create(function(pulse : Pulse<T>) : Propagation<T> {
			return if(value && (time == pulse.time)) {
				Propagate(pulse);
			} else {
				Negate;
			}
		}, [block]);
	}

	public static function ifThenElse(	stream : Stream<Bool>,
										thenBlock : Stream<T>,
										elseBlock : Stream<T>) : Stream<T> {
		var time = -1;
		var value = false;

		Streams.create(function(pulse : Pulse<Bool>) : Propagation<Bool> {
			time = pulse.time;
			value = pulse.value;
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
