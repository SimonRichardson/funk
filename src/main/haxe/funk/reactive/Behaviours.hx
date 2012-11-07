package funk.reactive;

import Lambda;

import funk.reactive.Behaviour;
import funk.reactive.Propagation;
import funk.reactive.Streams;

using Lambda;

class Behaviours {

	public static function constant<T>(value: T): Behaviour<T> {
		return Streams.identity().startsWith(value);
	}

	public static function sample(behaviour : Behaviour<Float>) : Behaviour<Float> {
		return Streams.timer(behaviour).startsWith(Process.stamp());
	}

	public static function zipIterable<T>(	behaviours: Iterable<Behaviour<T>>
											) : Behaviour<Iterable<T>>  {
		function mapToValue(): Iterable<T> {
        	return behaviours.map(function(behaviour) {
				return behaviour.value;
			});
      	}

		var stream = Streams.create(function(pulse) {
				return Propagate(pulse.withValue(mapToValue()));
			}, behaviours.map(function(behaviour) {
				return behaviour.stream;
			}));
		return stream.startsWith(mapToValue());
	}
}