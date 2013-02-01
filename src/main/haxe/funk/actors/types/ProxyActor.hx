package funk.actors.types;

import funk.actors.extensions.Actors;
import funk.collections.immutable.List;
import funk.actors.Actor;
import funk.actors.Reference;
import funk.actors.Message;
import funk.types.Deferred;
import funk.types.Either;
import funk.types.Option;
import funk.types.Promise;

using funk.collections.immutable.extensions.Lists;
using funk.actors.extensions.Actors;
using funk.actors.extensions.Headers;
using funk.actors.extensions.Messages;
using funk.types.extensions.Options;
using funk.types.extensions.Promises;

class ProxyActor<T> extends Actor<T> {

	private var _children : List<Actor<T>>;

	public function new() {
		super();

		_children = Nil;
	}

	override public function actor() : Actor<T> {
		var actor = new ProxySubActors(address());
		_children = _children.prepend(actor);
		return actor;
	}

	/*
	override private function createReference<R>(message : T) : Reference<T, R> {
		return new ReferenceImpl(this, message, function (	actor : Actor<R>,
															message : Message<T>
															) : Promise<Message<R>> {
			var deferred = new Deferred();
			var promise = deferred.promise();

			_recipients = _recipients.prepend(actor.address());

			var promises = Nil;

			_children.foreach(function (actor : Actor<T>) {
				// Note (Simon) : send to itself so it goes through correctly
				var promise = actor.dispatch(message.body().get());
				promises = promises.prepend(promise);
			});

			promises.awaitAll().pipe(deferred);

			return cast promise;
		});
	}

	override private function recieve<R>(message : Message<T>) : Promise<Message<List<R>>> {
		return switch (_status) {
			case Running:

				var deferred : Deferred<List<T>> = new Deferred();
				var promise : Promise<List<T>> = deferred.promise();

				var promises : List<Promise<Message<T>>> = Nil;
				_children.foreach(function (actor : Actor<T>) {
					// Note (Simon) : send to itself so it goes through correctly
					var promise = actor.dispatch(message.body().get());
					promises = promises.prepend(promise);
				});

				promises.awaitAll().map(function(items : List<Message<T>>) {
					return items.map(function (message : Message<T>) : T {
						return message.body().get();
					});
				}).pipe(deferred);

				var headers = message.headers();
				var result : Promise<Message<List<R>>> = promise.map(function(value : List<T>) {
					return tuple2(headers.invert(), cast value);
				});
				result;

			default: Promises.reject("Actor is not running");
		}
	}*/
}

private class ProxySubActors<T> extends Actor<T> {

	public function new(address : String) {
		super();

		_address = address;
	}
}
