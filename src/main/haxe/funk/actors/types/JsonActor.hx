package funk.actors.types;

import funk.collections.immutable.List;
import funk.actors.Actor;
import funk.actors.Reference;
import funk.actors.Message;
import funk.io.http.MimeType;
import funk.types.extensions.Anys;
import funk.types.Deferred;
import funk.types.Either;
import funk.types.Option;
import funk.types.Promise;

using funk.collections.immutable.extensions.Lists;
using funk.actors.extensions.Headers;
using funk.actors.extensions.Messages;
using funk.types.extensions.Options;
using funk.types.extensions.Promises;
using funk.net.http.extensions.UriRequests;

class JsonActor<T : Dynamic> extends Actor<T> {

	public function new() {
		super();
	}

	override private function onRecieve<T1, T2>(message : Message<T1>) : Promise<Message<T2>> {
		var deferred : Deferred<T2> = new Deferred();
		var promise : Promise<T2> = deferred.promise();

		Anys.toString(message.body().get()).fromUri().get(Content(Application(Json))).pipe(cast deferred);

		return promise.map(function(value : T2) {
			return tuple2(message.headers().invert(), value.toOption());
		});
	}
}
