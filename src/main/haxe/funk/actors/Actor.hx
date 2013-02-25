package funk.actors;

import funk.collections.immutable.List;
import funk.actors.Actor;
import funk.actors.ActorStatus;
import funk.actors.Header;
import funk.actors.Message;
import funk.actors.Reference;
import funk.reactive.Stream;
import funk.types.Deferred;
import funk.types.Function2;
import funk.types.Function3;
import funk.types.Option;
import funk.types.Promise;

using funk.collections.immutable.extensions.Lists;
using funk.actors.extensions.Headers;
using funk.actors.extensions.Messages;
using funk.reactive.extensions.Behaviours;
using funk.reactive.extensions.Streams;
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

	public function send<R>(value : T) : Reference<T, R> {
		return switch (_status) {
			case Running: onSend(value);
			default: Funk.error(ActorError("Actor is not running"));
		}
	}

	@:overridable
	private function onSend<R>(value : T) : Reference<T, R> {
		return new ReferenceImpl(this, value, function (	actor : Actor<R>,
															message : Message<T>,
															timeout : Stream<Float>
															) : Promise<Message<R>> {
			_recipients = _recipients.prepend(actor.address());

			var completed = false;

			var deferred = new Deferred();
			var promise = deferred.promise();

			// Note (Simon) : This is a different actor that the current one.
			var response = actor.recieve(message);
			response.progress(function(value) {
            	deferred.progress(value);
	        });
	        response.when(function(attempt) {
	        	completed = true;

	        	timeout.finish();

	            switch (attempt) {
	                case Failure(error):
	                	deferred.reject(error);
	                case Success(value):
	                	deferred.resolve(value);
	            }
	        });

			timeout.foreach(function(value) {
				if (!completed) {
					completed = true;

					timeout.finish();

					deferred.reject(ActorError('Actor has timed out after ${value}ms'));
				}
			});

			return cast promise;
		});
	}

	private function recieve<T1, T2>(message : Message<T1>) : Promise<Message<T2>> {
		return switch (_status) {
			case Running: onRecieve(message);
			default: Promises.reject("Actor is not running");
		}
	}

	@:overridable
	private function onRecieve<T1, T2>(message : Message<T1>) : Promise<Message<T2>> {
		var deferred : Deferred<Message<T2>> = new Deferred();
		var promise : Promise<Message<T2>> = deferred.promise();

		var headers = message.headers();
		deferred.resolve(message.map(function (value : Message<T1>) {
			return tuple2(headers.invert(), cast value.body());
		}));

		return promise;
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

private typedef Broadcaster<T1, T2> = Function3<Actor<T2>, Message<T1>, Stream<Float>, Promise<Message<T2>>>;

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

				_broadcaster(act, tuple2(headers, Some(_value)), Streams.identity(None));

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

	public function toActorWithTimeout(actor : Option<Actor<T2>>, time : Float) : Promise<Message<T2>> {
		return switch(actor) {
			case Some(act):
				var headers = Nil;
				headers = headers.prepend(Origin(_actor.address()));
				headers = headers.prepend(Recipient(act.address()));

				var timeout = Streams.timer(Behaviours.constant(time));

				_broadcaster(act, tuple2(headers, Some(_value)), timeout);

			case None: Promises.reject("Unexpected: Actor not found");
		};
	}
}
