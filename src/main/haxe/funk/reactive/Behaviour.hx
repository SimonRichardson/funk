package funk.reactive;

import funk.types.Function1;
import haxe.ds.Option;
import funk.reactive.Propagation;
import funk.reactive.Pulse;
import funk.reactive.extensions.Pulses;
import funk.reactive.extensions.Streams;
import funk.collections.extensions.CollectionsUtil;

using funk.reactive.extensions.Pulses;
using funk.reactive.extensions.Streams;
using funk.collections.extensions.CollectionsUtil;

class Behaviour<T> {

	private var _stream : Stream<T>;

	private var _pulse : Function1<Pulse<T>, Propagation<T>>;

	private var _value : T;

	public function new(stream: Stream<T>, value : T, pulse : Function1<Pulse<T>, Propagation<T>>) {
		_value = value;
		_pulse = pulse;

		_stream = Streams.create(function(pulse : Pulse<T>) : Propagation<T> {
			var prop = _pulse(pulse);
			switch(prop) {
				case Propagate(value):
					_value = value.value();
				case Negate:
			}
			return prop;
		}, Some([stream.steps()].toCollection()));
	}

	public function stream() : Stream<T> {
		return _stream;
	}

	public function value() : T {
		return _value;
	}
}

class BehaviourTypes {

	public static function constant<T>(value: T): Behaviour<T> {
		return Streams.identity(None).startsWith(value);
	}

	public static function dispatch<T>(behaviour : Behaviour<T>, value : T) : Void {
		behaviour.stream().dispatch(value);
	}

	public static function lift<T, R>(behaviour : Behaviour<T>, func : Function1<T, R>) : Behaviour<R> {
		return behaviour.stream().map(func).startsWith(func(behaviour.value()));
	}

	public static function map<T, R>(	behaviour : Behaviour<T>,
										stream : Stream<T>,
										mapper : Behaviour<Function1<T, R>>
										) : Behaviour<R> {
		return stream.map(function(x) {
			return mapper.value()(x);
		}).startsWith(mapper.value()(behaviour.value()));
	}

	public static function sample(behaviour : Behaviour<Float>) : Behaviour<Float> {
		return Streams.timer(behaviour).startsWith(Process.stamp());
	}

	public static  function values<T>(behaviour : Behaviour<T>) : Collection<T> {
		return behaviour.stream().values();
	}

	public static function zip<T1, T2>(behaviour : Behaviour<T1>, that : Behaviour<T2>) : Behaviour<Tuple2<T1, T2>> {
		return zipWith(behaviour, that, function(a, b) {
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
			}, Some(behaviours.map(function(behaviour) {
				return behaviour.stream();
			}).toCollection()));
		return stream.startsWith(mapToValue());
	}

	public static function zipWith<T, E1, E2>(	behaviour : Behaviour<T>,
												that : Behaviour<E1>,
												func : Function2<T, E1, E2>
												) : Behaviour<E2> {
		var sources : Array<Dynamic> = [behaviour, that];
		var stream = Streams.create(function(pulse : Pulse<E1>) : Propagation<E2> {
			var result = func(behaviour.value(), that.value());
			return Propagate(pulse.withValue(result));
		}, Some(sources.toCollection()));

		return stream.startsWith(func(behaviour.value(), that.value()));
	}
}
