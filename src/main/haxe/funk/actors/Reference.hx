package funk.actors;

import funk.actors.Actor;
import funk.actors.Message;
import funk.types.Option;
import funk.types.Promise;

typedef Reference<T1, T2> = {

	function to(actor : Option<Actor<T2>>) : Promise<Message<T2>>;

	function toAddress(address : String) : Promise<Message<T2>>;
}