package funk.actors.types.mvc;

import funk.actors.Actor;
import funk.actors.Message;
import funk.collections.immutable.List;
import funk.reactive.Stream;
import funk.reactive.extensions.Streams;
import funk.types.Deferred;
import funk.types.Option;
import funk.types.Promise;

using funk.actors.extensions.Headers;
using funk.actors.extensions.Messages;
using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Promises;

enum Requests<T, K> {
    Add(value : T);
    AddAt(value : T, key : K);
    AddAll(value : List<T>);
    Get;
    GetAt(key : K);
    Remove(value : T);
    RemoveAt(key : K);
    RemoveAll;
    Sync;
    Update(a : T, b : T);
    UpdateAll(a : T);
    UpdateAt(value : T, key : K);
}

class Model<V, K> extends Actor<Requests<V, K>> {

	private var stream : Stream<Dynamic>;

	public function new() {
		super();

		stream = Streams.identity(None);
	}

	public function react<R>() : Stream<R> {
		return cast stream;
	}

	private function add(value : V) : Promise<Option<V>> {
		return Promises.dispatch(None);
	}

	private function addAt(value : V, key : K) : Promise<Option<V>> {
		return Promises.dispatch(None);
	}

	private function addAll(value : List<T>) : Promise<Option<V>> {
		return Promises.dispatch(None);
	}

	private function get() : Promise<Option<V>> {
		return Promises.dispatch(None);
	}

	private function getAt(key : K) : Promise<Option<V>> {
		return Promises.dispatch(None);
	}

	private function remove(value : V) : Promise<Option<V>> {
		return Promises.dispatch(None);
	}

	private function removeAt(key : K) : Promise<Option<V>> {
		return Promises.dispatch(None);
	}

	private function removeAll() : Promise<Option<V>> {
		return Promise.dispatch(None);
	}

	private function sync() : Promise<Option<V>> {
		return Promises.dispatch(None);
	}

	private function update(a : V, b : V) : Promise<Option<V>> {
		return Promises.dispatch(None);
	}

	private function updateAll(a : V) : Promise<Option<V>> {
		return Promises.dispatch(None);
	}

	private function updateAt(value : V, key : K) : Promise<Option<V>> {
		return Promises.dispatch(None);
	}

	private function data<R>() : Option<R> {
		return None;
	}

	override private function onRecieve<T1, T2>(message : Message<Requests<V, K>>) : Promise<Message<T2>> {
		return cast switch(message.body()) {
			case Some(value):

				var response : Promise<Option<V>> = switch(value) {
					case Add(value): add(value);
					case AddAt(value, key): addAt(value, key);
					case AddAll(value): addAll(value);
					case Get: get();
					case GetAt(key): getAt(key);
					case Remove(value): remove(value);
					case RemoveAt(key): removeAt(key);
					case RemoveAll: removeAll();
					case Sync: sync();
					case Update(a, b): update(a, b);
					case UpdateAll(a): updateAll(a);
					case UpdateAt(value, key): updateAt(value, key);
				};

				// Invert the headers and merge the result to a message.
				var promise : Promise<Message<V>> = response.map(function(value : Option<V>) {
					return tuple2(message.headers().invert(), value);
				});

				// Automatically dispatch the data.
				react().dispatch(data());

				promise;

			// (Simon) Not entirely sure what to do here, as we've received a empty message.
			case None: Promises.dispatch(tuple2(message.headers().invert(), None));
		};
	}
}
