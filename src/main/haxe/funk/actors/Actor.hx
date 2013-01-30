package funk.actors;

import funk.collections.immutable.List;
import funk.actors.Actor;
import funk.actors.ActorStatus;
import funk.actors.Header;
import funk.actors.Message;
import funk.actors.Reference;
import funk.types.Deferred;
import funk.types.Function2;
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
			case Running: createReference(message);
			default: Funk.error(ActorError("Actor is not running"));
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
				Promises.reject("Actor is not running");
		}
	}

	@:overridable
	private function createReference(message : T1) : Reference<T1, T2> {
		return new ReferenceImpl(this, message, function (	actor : Actor<T1, T2>, 
															message : Message<T1>
															) : Promise<Message<T2>> {
			var deferred = new Deferred();
			var promise = deferred.promise();
			
			_recipients = _recipients.prepend(actor);
			
			actor.recieve(message).pipe(deferred);
			
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

private typedef Broadcaster<T1, T2> = Function2<Actor<T1, T2>, Message<T1>, Promise<Message<T2>>>;

private class ReferenceImpl<T1, T2> {

	private var _actor : Actor<T1, T2>;

	private var _value : T1;

	private var _broadcaster : Broadcaster<T1, T2>;

	public function new(actor : Actor<T1, T2>, value : T1, broadcaster : Broadcaster<T1, T2>) {
		_actor = actor;
		_value = value;
		_broadcaster = broadcaster;
	}

	public function to(actor : Option<Actor<T1, T2>>) : Promise<Message<T2>> {
		return switch(actor) {
			case Some(act):
				var headers = Nil;
				headers = headers.prepend(Origin(_actor.address()));
				headers = headers.prepend(Recipient(act.address()));

				_broadcaster(act, tuple2(headers, Some(_value)));

			case None: Promises.reject("Unexpected: Actor not found");
		};
	}

	public function toAddress(address : String) : Promise<Message<T2>> {
		return to(_actor.recipients().find(function (actor) {
			return actor.address() == address;
		}));
	}
}

