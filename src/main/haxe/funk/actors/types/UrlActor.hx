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

class UrlActor<T1 : String, T2 : String> extends Actor<T1, T2> {

	public function new() {
		super();
	}

	override private function recieve(message : Message<T1>) : Promise<Message<T2>> {
		var deferred = new Deferred();
		var promise = deferred.promise();

		//message.body().fromUri().get().pipe(deferred);

		return cast promise;
	}
}