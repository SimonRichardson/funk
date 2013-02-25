package funk.actors.types;

import funk.actors.extensions.Actors;
import funk.collections.immutable.List;
import funk.actors.Actor;
import funk.actors.Reference;
import funk.actors.Message;
import funk.reactive.Stream;
import funk.types.Deferred;
import funk.types.Either;
import funk.types.extensions.Promises;
import haxe.ds.Option;
import funk.types.Promise;

using funk.collections.immutable.extensions.Lists;

using funk.actors.extensions.Headers;
using funk.actors.extensions.Messages;
using funk.reactive.extensions.Behaviours;
using funk.reactive.extensions.Streams;
using funk.types.extensions.Options;
using funk.types.extensions.Promises;
using funk.actors.extensions.Actors;

class ProxyActor<T> extends Actor<T> {

	private var _children : List<Actor<T>>;

	public function new() {
		super();

		_children = Nil;
	}

	override public function actor() : Actor<T> {
		var actor = new ProxyAgentActor(address());
		_children = _children.prepend(actor);
		return actor;
	}

	public function agent() : ProxyAgentActor<T> {
		return cast actor();
	}

	override private function onRecieve<T1, T2>(message : Message<T1>) : Promise<Message<T2>> {
		var promises : List<Promise<Message<T1>>> = Nil;

		_children.foreach(function (actor : Actor<T>) {
			promises = promises.prepend(actor.dispatch(cast message.body().get()));
		});

		var deferred : Deferred<List<T2>> = new Deferred();
		var promise : Promise<List<T2>> = deferred.promise();

		promises.awaitAll().map(function(items : List<Message<T1>>) {
			return items.map(function (message : Message<T1>) : T2 {
				return cast message.body().get();
			});
		}).pipe(deferred);

		return promise.map(function(value : List<T2>) {
			return tuple2(message.headers().invert(), cast value.toOption());
		});
	}
}

class ProxyAgentActor<T> extends Actor<T> {

	public function new(address : String) {
		super();

		_address = address;
	}

	override private function onRecieve<T1, T2>(message : Message<T1>) : Promise<Message<T2>> {
		return onMessage(message).map(function(value : T2) {
			return tuple2(message.headers(), value.toOption());
		});
	}

	dynamic public function onMessage<T1, T2>(message : Message<T1>) : Promise<T2> {
		return Promises.empty();
	}
}
