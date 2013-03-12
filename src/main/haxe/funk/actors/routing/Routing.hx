package funk.actors;

class Router extends Actor {

    public function new() {
    }

    override public function receive<T>(message : T) : Void {
    	switch (message) {
    		case Terminated(child): context().stop(self);
    		case _: routerReceive(message);
    	}
    }

    public function routerReceive<T>(message : T) : Void {
    	switch (message) {
    		case _:
    	}
    }
}
