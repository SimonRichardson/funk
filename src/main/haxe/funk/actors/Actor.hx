package funk.actors;

import funk.collections.immutable.List;
import funk.actors.Actor;
import funk.actors.ActorStatus;
import funk.actors.Reference;
import funk.actors.Message;
import funk.types.Deferred;
import funk.types.Option;
import funk.types.Promise;

using funk.collections.immutable.extensions.Lists;

class Actor<T1, T2> {

	private var _address : String;

	private var _status : ActorStatus;

	private var _recipients : List<Actor<T1, T2>>;

	public function new() {
		_status = Running;
		_recipients = Nil.prepend(this);

		_address = generateAddress();
	}

	public function actor() : Actor<T1, T2> {
		var actor = new Actor();
		_recipients = _recipients.prepend(actor);
		return actor;
	}

	public function status() : ActorStatus {
		return _status;
	}

	public function address() : String {
		return _address;
	}

	public function recipients() : List<Actor<T1, T2>> {
		return _recipients;
	}

	public function send(message : T1) : Reference<T1, T2> {
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

							// Note (Simon) : If this was a web actor, then this wouldn't complete
							// until after the content has finished.
							deferred.resolve(cast msg);
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
