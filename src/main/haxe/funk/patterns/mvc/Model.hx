package funk.patterns.mvc;

import funk.actors.Actor;
import funk.actors.Message;
import funk.collections.immutable.List;
import funk.patterns.mvc.Choices;
import funk.patterns.mvc.Observable;
import funk.types.Deferred;
import funk.types.extensions.Promises;
import funk.types.Option;
import funk.types.Promise;

using funk.actors.extensions.Messages;
using funk.collections.immutable.extensions.Lists;

class Model<T, K> extends Actor<EnumValue, T> {

	private var _listeners : List<Actor<EnumValue, T>>;

	public function new() {
		super();

		_listeners = Nil;
	}

	private function get() : Promise<Message<T>> {
		return Promises.dispatch(Empty);
	}

	override private function recieve(message : Message<EnumValue>) : Promise<Message<T>> {
		return switch (_status) {
			case Running:
				var value = message.body();
				if (Std.is(value, Observable)) {
					var observable : Observable<T> = cast value;
					switch(observable) {
						case AddListener(value): _listeners = _listeners.prepend(value);
						case RemoveListener(value):
							_listeners = _listeners.filterNot(function(val) {
								return val == value;
							});
					}
					// Send back an empty promise.
					Promises.empty();

				} else if (Std.is(value, Choices)) {
					var choices : Choices<T, K> = cast value;
					switch(choices) {
						case Get: get();
						default: Promises.empty();
					}
				}
			default:
				Funk.error(ActorError("Actor is not running"));
		}
	}
}
