package funk.actors.types;

import funk.collections.immutable.List;
import funk.actors.Actor;
import funk.actors.Reference;
import funk.actors.Message;
import funk.types.Deferred;
import funk.types.Either;
import funk.types.Option;
import funk.types.Promise;

using funk.collections.immutable.extensions.Lists;
using funk.actors.extensions.Messages;
using funk.types.extensions.Promises;

class ProxyActor<T1, T2> extends Actor<T1, T2> {

	private var _children : List<Actor<T1, T2>>;

	public function new() {
		super();

		_children = Nil;
	}

	override public function actor() : Actor<T1, T2> {
		var actor = new ProxySubActors(address());
		_children = _children.prepend(actor);
		return actor;
	}

	override public function send(message : T1) : Reference<T1, T2> {
		return new Reference(this, message, function(	actor : Option<Actor<T1, T2>>,
														message : Option<Message<T1>>
														) : Promise<Message<T2>> {
			var deferred = new Deferred();
			var promise = deferred.promise();

			switch(actor) {
				case Some(act):
					switch (message) {
						case Some(msg):
							_recipients = _recipients.prepend(act);

							var promises = None;
							_children.foreach(function (actor : Actor<T1, T2>) {
								// We need to some how call a resolve on each one.
								var childPromise = actor.send(msg.body());
								switch(promises) {
									case Some(value):
										//promises = Some(value.zip(childPromise));
									case None:
										//promises = Some(childPromise);
								}
							});

							switch(promises) {
								case Some(value):
									value.when(function (either) {
										switch(either) {
											case Left(error):
												deferred.reject(error);
											case Right(value):
												// TODO (Simon) : Work out how to flatten a tuple (N) completely.
												// deferred.resolve(value);
										}
									});
								case None:
							}

						case None:
							deferred.reject(ActorError("No message supplied"));
					}
				case None:
					deferred.reject(ActorError("No actor supplied"));
			}

			return promise;
		});
	}
}

private class ProxySubActors<T1, T2> extends Actor<T1, T2> {

	public function new(address : String) {
		super();

		_address = address;
	}
}
