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
using funk.actors.extensions.Headers;
using funk.actors.extensions.Messages;
using funk.types.extensions.Options;
using funk.types.extensions.Promises;


class Actor<T> {

	private var _address : String;

	private var _status : ActorStatus;

	private var _associates : List<Actor<T>>;

	private var _recipients : List<String>;

	public function new() {
		_status = Running;

		_address = generateAddress();

		_associates = Nil.prepend(this);
		_recipients = Nil.prepend(_address);

		// Each actor is now added to the global registrar.
		Registrar.add(this);
	}

	public function actor() : Actor<T> {
		var actor = new Actor();
		_associates = _associates.prepend(actor);
		return actor;
	}

	public function status() : ActorStatus {
		return _status;
	}

	public function address() : String {
		return _address;
	}

	public function associates() : List<Actor<T>> {
		return _associates;
	}

	public function recipients() : List<String> {
		return _recipients;
	}

	public function belongsTo(actor : Actor<T>) : Void {
		_associates = _associates.prepend(actor);
	}

	public function start() : Actor<T> {
		_status = Running;
		return this;
	}

	public function stop() : Actor<T> {
		_status = Stopped;
		return this;
	}

	public function send<R>(message : T) : Reference<T, R> {
		return switch (_status) {
			case Running: createReference(message);
			default: Funk.error(ActorError("Actor is not running"));
		}
	}

	@:overridable
	private function recieve<R>(message : Message<T>) : Promise<Message<R>> {
		return switch (_status) {
			case Running:
				var deferred : Deferred<Message<T>> = new Deferred();
				var promise : Promise<Message<T>> = deferred.promise();

				deferred.resolve(message);

				var headers = message.headers();
				var result : Promise<Message<R>> = promise.map(function(value : Message<T>) {
					return tuple2(headers.invert(), cast value);
				});
				result;

			default: Promises.reject("Actor is not running");
		}
	}

	@:overridable
	private function createReference<R>(message : T) : Reference<T, R> {
		return new ReferenceImpl(this, message, function (	actor : Actor<R>, 
															message : Message<T>
															) : Promise<Message<R>> {
			var deferred = new Deferred();
			var promise = deferred.promise();
			
			_recipients = _recipients.prepend(actor.address());
			
			actor.recieve(cast message).pipe(deferred);
			
			return cast promise;
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

private typedef Broadcaster<T1, T2> = Function2<Actor<T2>, Message<T1>, Promise<Message<T2>>>;

class ReferenceImpl<T1, T2> {

	private var _actor : Actor<T1>;

	private var _value : T1;

	private var _broadcaster : Broadcaster<T1, T2>;

	public function new(actor : Actor<T1>, value : T1, broadcaster : Broadcaster<T1, T2>) {
		_actor = actor;
		_value = value;
		_broadcaster = broadcaster;
	}

	public function to(actor : Option<Actor<T2>>) : Promise<Message<T2>> {
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
		// Try and get a know associate
		var associate = _actor.associates().find(function(actor) {
			return actor.address() == address;
		});

		// Else speak to the registrar
		return to(switch(associate) {
			case Some(_): cast associate;
			case None: 
				// See if it even belongs to the recipients.
				var recipient = _actor.recipients().find(function(value) {
					return address == value;
				});

				switch(recipient) {
					case Some(address): cast Registrar.find(address);
					case None: None;
				}
		});
	}
}

