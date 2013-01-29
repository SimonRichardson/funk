package funk.patterns.mvc;

import funk.actors.Actor;
import funk.collections.immutable.List;

using funk.actors.extensions.Messages;
using funk.collections.immutable.extensions.Lists;

enum State<T> {
	GetState;
	SetState(value : T);
	UpdateState(actor : Model<T>, value : T);
}

class Model<T> extends Actor<T, T> {
	
	private var _value : T;

	private var _listeners : List<Actor<T, T>>;

	public function new() {
		super();

		_listeners = Nil;
	}

	private function handle(deferred : Deferred, message : Message<T>) : Void {

	}

	override private function recieve(message : Message<T>) : Promise<Message<T>> {
		return switch (_status) {
			case Running:
				var deferred = new Deferred();
				var promise = deferred.promise();

				var value = message.getBody();
				if (Std.is(value, Observable)) {
					switch(value) {
						case AddListener(value): 
							_listeners = _listeners.prepend(value);
							deferred.resolve(value);

						case RemoveListener(value): 
							_listeners = _listeners.filterNot(function(val) {
								return val == value;
							});
							deferred.resolve(value);
					}
				} else if (Std.is(value, State)) {
					switch(value) {
						case SetState(s): 
							_value = s;
							_listeners.foreach(function(actor) {
								send(UpdateState(_value)).to(actor);
							});
							deferred.resolve(_value);

						case GetState: 
							deferred.resolve(_value);
					}
				} else {
					handle(deferred, value);
				}
				
				promise;
			default:
				Funk.error(ActorError("Actor is not running"));
		}
	}
}