package funk.patterns.mvc;

import funk.actors.Actor;
import funk.actors.Message;
import funk.collections.immutable.List;
import funk.patterns.mvc.Choices;
import funk.patterns.mvc.Observable;
import funk.types.Deferred;
import funk.types.Option;
import funk.types.Promise;

using funk.actors.extensions.Headers;
using funk.actors.extensions.Messages;
using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Promises;

class Model<T, K> extends Actor<EnumValue, T> {

	private var _listeners : List<Actor<T, K>>;

	public function new() {
		super();

		_listeners = Nil;
	}

	private function add(value : T) : Promise<Option<T>> {
		return Promises.dispatch(None); 
	}

	private function addAt(value : T, key : K) : Promise<Option<T>> {
		return Promises.dispatch(None); 
	}

	private function get() : Promise<Option<T>> {
		return Promises.dispatch(None);
	}

	private function getAt(key : K) : Promise<Option<T>> {
		return Promises.dispatch(None);
	}

	override private function recieve(message : Message<EnumValue>) : Promise<Message<T>> {
		return switch (_status) {
			case Running:
				var headers = message.headers();
				
				var body = message.body();

				switch (body) {
					case Some(value):

						if (Std.is(value, Observable)) {
							var observable : Observable<T, K> = cast value;
							switch(observable) {
								case AddListener(value): _listeners = _listeners.prepend(value);
								case RemoveListener(value):
									_listeners = _listeners.filterNot(function(val) {
										return val == value;
									});
							}
							// (Simon) Send back an empty promise.
							Promises.empty();

						} else if (Std.is(value, Choices)) {
							
							var choices : Choices<T, K> = cast value;
							var response = switch(choices) {
								case Add(value): add(value);
								case AddAt(value, key): addAt(value, key);
								case Get: get();
								case GetAt(key): getAt(key);
								default: 
									Funk.error(ActorError("Not implemented yet"));
							};

							response.map(function (value : Option<T>) {
								return tuple2(headers.invert(), value);
							});

						} else {
							Promises.empty();
						}

					// (Simon) Not entirely sure what to do here, as we've received a empty message.
					case None: Promises.empty();
				}
				
			default: Promises.reject("Actor is not running");
		}
	}
}
