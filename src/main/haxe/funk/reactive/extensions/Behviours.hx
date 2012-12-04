package funk.reactive.extensions;

import Lambda;
import funk.collections.Collection;
import funk.reactive.Behaviour;
import funk.reactive.Propagation;
import funk.reactive.extensions.Streams;

using Lambda;
using funk.reactive.extensions.Streams;

class Behaviours {

	public static function constant<T>(value: T): Behaviour<T> {
		return Streams.identity().startsWith(value);
	}

	public function emit<T>(stream : Stream<T>, value : T) : Void {
		stream.emit(value);
	}

	public static function lift<T, R>(stream : Stream<T>, func : Function1<T, R>) : Behaviour<R> {
		return stream.map(func).startsWith(func(stream.value()));
	}

	public function map<T, R>(stream : Stream<T>, behaviour : Behaviour<Function1<T, R>>) : Behaviour<R> {
		return stream.map(function(x) {
			return behaviour.value(x);
		}).startsWith(behaviour.value(stream.value()));
	}

	public static function sample(behaviour : Behaviour<Float>) : Behaviour<Float> {
		return Streams.timer(behaviour).startsWith(Process.stamp());
	}

	public function values<T>(stream : Stream<T>) : StreamValues<T> {
		return stream.values();
	}

	public function zip<T1, T2>(stream : Stream<T1>, behaviour : Behaviour<T2>) : Behaviour<Tuple2<T1, T2>> {
		return zipWith(stream, behaviour, function(a, b) {
			return tuple2(a, b);
		});
	}

	public static function zipIterable<T>(	behaviours: Collection<Behaviour<T>>
											) : Behaviour<Collection<T>>  {
		function mapToValue(): Collection<T> {
        	return behaviours.map(function(behaviour) {
				return behaviour.value();
			});
      	}

		var stream = Streams.create(function(pulse) {
				return Propagate(pulse.withValue(mapToValue()));
			}, behaviours.map(function(behaviour) {
				return behaviour.stream;
			}));
		return stream.startsWith(mapToValue());
	}

	public function zipWith<E1, E2>(	stream : Stream<T>, 
										behaviour : Behaviour<E1>, 
										func : Function2<T, E1, E2>
										) : Behaviour<E2> {
		return Streams.create(function(pulse : Pulse<E1>) : Propagation<E2> {
			return Propagate(pulse.withValue(func(stream.value(), behaviour.value())));
		}, Some([stream, behaviour].toCollection())).startsWith(func(stream.value(), behaviour.value()));
	}	
}
