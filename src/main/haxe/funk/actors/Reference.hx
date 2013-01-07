package funk.actors;

import funk.collections.immutable.List;
import funk.actors.Actor;
import funk.actors.Header;
import funk.actors.Message;
import funk.types.Function2;
import funk.types.Option;
import funk.types.Promise;

using funk.collections.immutable.extensions.Lists;

class Reference<T> {

	private var _actor : Actor<T>;

	private var _body : T;

	private var _broadcaster : Function2<Option<Actor<T>>, Option<Message<T>>, Promise<Message<T>>>;

	public function new(	actor : Actor<T>, 
							body : T,
							broadcaster : Function2<Option<Actor<T>>, Option<Message<T>>, Promise<Message<T>>>
							) {
		_actor = actor;
		_body = body;
		_broadcaster = broadcaster;
	}

	public function to(actor : Option<Actor<T>>) : Promise<Message<T>> {
		return switch (actor) {
			case Some(act):
				var headers = Nil;
				headers = headers.prepend(Origin(_actor.address()));	
				headers = headers.prepend(Recipient(act.address()));

				_broadcaster(actor, Some(Message(headers, _body)));
			case None:
				_broadcaster(actor, None);
		}
	}

	public function toAddress(address : String) : Promise<Message<T>> {	
		return to(_actor.recipients().find(function (actor) {
			return actor.address() == address;
		}));
	}
}