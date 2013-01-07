package funk.actors;

import funk.collections.immutable.List;
import funk.actors.Actor;
import funk.actors.Reference;
import funk.actors.Message;
import funk.types.Deferred;
import funk.types.Option;
import funk.types.Promise;

using funk.collections.immutable.extensions.Lists;

class Actor<T> {

	private var _address : String;

	private var _recipients : List<Actor<T>>;

	public function new() {
		_recipients = Nil.prepend(this);

		_address = generateAddress();
	}

	public function actor() : Actor<T> {
		var actor = new Actor();
		_recipients = _recipients.prepend(actor);
		return actor;
	}

	public function address() : String {
		return _address;
	}

	public function recipients() : List<Actor<T>> {
		return _recipients;
	}

	public function send(message : T) : Reference<T> {
		return new Reference(this, message, function(	actor : Option<Actor<T>>, 
														message : Option<Message<T>>
														) : Promise<Message<T>> {
			var deferred = new Deferred();
			var promise = deferred.promise();

			switch(actor) {
				case Some(act): 
					switch (message) {
						case Some(msg):
							_recipients = _recipients.prepend(act);

							// Note (Simon) : If this was a web actor, then this wouldn't complete
							// until after the content has finished.
							deferred.resolve(msg);
						case None:
							deferred.reject(ActorError("No message supplied"));
					}
				case None: 
					deferred.reject(ActorError("No actor supplied"));
			}

			return promise;
		});
	}

	private function generateAddress() : String {
		var buffer = "";
		var total = 6;

		for(i in 0...total) {
			buffer += Math.floor(Math.random() * 255);

			if (i < total - 1) {
				buffer += ".";
			}
		}

		return buffer;
	}
}