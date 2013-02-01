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
using funk.net.http.extensions.UriRequests;

class UrlActor<T : String> extends Actor<T> {

	public function new() {
		super();
	}

	/*
	override private function recieve<R>(message : Message<T>) : Promise<Message<R>> {
		return switch (_status) {
			case Running:
				var deferred = new Deferred();
				var promise = deferred.promise();

				message.body().fromUri().get().pipe(deferred);

			default:
				Promises.reject("Actor is not running");
		}
	}
	*/
}
