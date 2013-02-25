package funk.actors;

import funk.actors.Actor;
import funk.actors.Message;
import haxe.ds.Option;
import funk.types.Promise;

typedef Reference<T1, T2> = {

	function to(actor : Option<Actor<T2>>) : Promise<Message<T2>>;

	function toAddress(address : String) : Promise<Message<T2>>;

    function toActorWithTimeout(actor : Option<Actor<T2>>, time : Float) : Promise<Message<T2>>;
}
