package funk.actors;

import funk.collections.immutable.List;
import funk.actors.Actor;
import funk.actors.Header;
import funk.actors.Message;
import funk.types.Function2;
import funk.types.Option;
import funk.types.Promise;

using funk.collections.immutable.extensions.Lists;

class Reference<T1, T2> {

	private var _actor : Actor<T1, T2>;

	private var _body : T1;

	private var _broadcaster : Function2<Option<Actor<T1, T2>>, Option<Message<T1>>, Promise<Message<T2>>>;

	public function new(	actor : Actor<T1, T2>,
							body : T1,
							broadcaster : Function2<Option<Actor<T1, T2>>, Option<Message<T1>>, Promise<Message<T2>>>
							) {
		_actor = actor;
		_body = body;
		_broadcaster = broadcaster;
	}

	public function to(actor : Option<Actor<T1, T2>>) : Promise<Message<T2>> {
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

	public function toAddress(address : String) : Promise<Message<T2>> {
		return to(_actor.recipients().find(function (actor) {
			return actor.address() == address;
		}));
	}
}
