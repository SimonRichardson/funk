package funk.reactive.behaviours;

import funk.Funk;
import funk.reactive.Behaviour;
import funk.reactive.Propagation;
import funk.reactive.extensions.Behaviours;
import funk.reactive.extensions.Propagations;
import funk.reactive.extensions.Streams;
import funk.reactive.streams.StreamBool;
import funk.signals.Signal0;
import funk.types.Tuple1;

using funk.reactive.extensions.Streams;
using funk.reactive.extensions.Behaviours;
using funk.reactive.streams.StreamBool;

class BehaviourBool {

	public static function not(behaviour : Behaviour<Bool>) : Behaviour<Bool> {
		return StreamBool.not(behaviour.stream()).startsWith(!behaviour.value());
	}

	public static function ifThen<T>(	condition : Behaviour<Bool>,
										thenBlock : Behaviour<T>) : Behaviour<T> {
		return StreamBool.ifThen(condition.stream(), thenBlock.stream()).startsWith(
			if(condition.value()) {
				thenBlock.value();
			});
	}

	public static function ifThenElse<T>(	condition : Behaviour<Bool>,
											thenBlock : Behaviour<T>,
											elseBlock : Behaviour<T>) : Behaviour<T> {
		return StreamBool.ifThenElse(condition.stream(), thenBlock.stream(), elseBlock.stream()).startsWith(
			if(condition.value()) {
				thenBlock.value();
			} else {
				elseBlock.value();
			});
	}
}
