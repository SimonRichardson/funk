package funk.actors;

enum State {
	Pending;
	Running;
	Failed;
	Aborted;
}

enum Message<T> {
	Message(data : T);
}

enum ActorAddress {
	Address(address : String);
}

class ActorAddresses {

	public static function address(value : ActorAddress) : Option<String> {
		return Type.getEnumParameters(value)[0].toOption();
	}

	public static function safe(value : ActorAddress) : ActorAddress {
		var uid = Math.floor(Math.random() + Date.now().getTime()).toString();
		return Address(switch(address(value)) {
			case Some(val): Std.format("$uid@$val");
			case None: uid;
		});
	}
}


typedef ActorAddress = {
	function address() : Option<String>;
}

typedef Actor = {>ActorAddress

	function actor() : Actor;

	function send<T1, T2>(data : T1) : Promise<T2>;
}

class LocalActor<T> {

	public function new() {

	}

	public function address() : Option<String> {
		return None;
	}

	public function belongsTo(parent : Actor) : Actor {
		return parent.attach(this);
	}

	public function send(message : Message) : Promise<T> {

	}
}

var sys = new Actor();
var l0 = sys.actor(function (a) {
	return a;
});
sys.send(l0, "Hello");