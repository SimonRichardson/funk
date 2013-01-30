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
using funk.actors.extensions.Messages;
using funk.types.extensions.Promises;

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

	public function belongsTo(actor : Actor<T1, T2>) : Void {
		_recipients = _recipients.prepend(actor);
	}

	public function start() : Actor<T1, T2> {
		_status = Running;
		return this;
	}

	public function stop() : Actor<T1, T2> {
		_status = Stopped;
		return this;
	}

	public function send(message : T1) : Reference<T1, T2> {
		return switch (_status) {
			case Running:
				new Reference(this, message, function (actor, message) {
					var deferred = new Deferred();
					var promise = deferred.promise();

					switch(actor) {
						case Some(act):
							switch (message) {
								case Some(msg):
									_recipients = _recipients.prepend(act);

									act.recieve(msg).pipe(deferred);
								case None:
									deferred.reject(ActorError("No message supplied"));
							}
						case None:
							deferred.reject(ActorError("No actor supplied"));
					}

					return promise;
				});
			default:
				Funk.error(ActorError("Actor is not running"));
		}
	}

	@:overridable
	private function recieve(message : Message<T1>) : Promise<Message<T2>> {
		return switch (_status) {
			case Running:
				var deferred = new Deferred();
				var promise = deferred.promise();

				deferred.resolve(message.map(function (message) {
					return cast message;
				}));

				promise;
			default:
				Funk.error(ActorError("Actor is not running"));
		}
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
