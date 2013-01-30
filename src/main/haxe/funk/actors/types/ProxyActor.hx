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
using funk.actors.extensions.Messages;
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

	override private function createReference<R>(message : T) : Reference<R> {
		return new Reference(this, message, function(	actor : Actor<R>,
														message : Message<T>
														) : Promise<Message<R>> {
			var deferred = new Deferred();
			var promise = deferred.promise();

			_recipients = _recipients.prepend(act);

			var promises = Nil;
			
			_children.foreach(function (actor : Actor<T>) {
				// Note (Simon) : send to itself so it goes through correctly
				var promise = actor.dispatch(message.body());
				promises = promises.prepend(promise);
			});

			promises.awaitAll().pipe(deferred);

			return promise;
		});
	}
}

private class ProxySubActors<T> extends Actor<T> {

	public function new(address : String) {
		super();

		_address = address;
	}
}
