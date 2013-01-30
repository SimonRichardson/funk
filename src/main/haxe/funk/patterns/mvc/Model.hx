package funk.patterns.mvc;

import funk.actors.Actor;
import funk.actors.Message;
import funk.collections.immutable.List;
import funk.patterns.mvc.Choices;
import funk.reactive.Stream;
import funk.reactive.extensions.Streams;
import funk.types.Deferred;
import funk.types.Option;
import funk.types.Promise;

using funk.actors.extensions.Headers;
using funk.actors.extensions.Messages;
using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Promises;

class Model<T, K> extends Actor<Choices<T, K>> {

	private var stream : Stream<Dynamic>;

	public function new() {
		super();

		stream = Streams.identity(None);
	}

	public function react<R>() : Stream<R> {
		return cast stream;
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

	private function data<R>() : Option<R> {
		return None;
	}

	override private function recieve<R>(message : Message<Choices<T, K>>) : Promise<Message<R>> {
		return cast switch (_status) {
			case Running:
				var headers = message.headers();
				
				var body = message.body();

				switch (body) {
					case Some(value):
							
						var response : Promise<Option<T>> = switch(value) {
							case Add(value): add(value);
							case AddAt(value, key): addAt(value, key);
							case Get: get();
							case GetAt(key): getAt(key);
							default: 
								Funk.error(ActorError("Not implemented yet"));
						};

						react().dispatch(data());

						response.map(function (value : Option<T>) {
							return tuple2(headers.invert(), cast value);
						});

					// (Simon) Not entirely sure what to do here, as we've received a empty message.
					case None: Promises.dispatch(tuple2(headers.invert(), None));
				}
				
			default: 
				Promises.reject("Actor is not running");
		}
	}
}
