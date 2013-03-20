package funk.actors.routing;

using funk.actors.Actor;

class Router extends Actor {

    public function new() {
        super();
    }

    override public function receive(message : EnumValue) : Void {
        switch (message) {
            case ActorMessage:
                switch(cast message) {
                    case Terminated(_): context().stop(self());
                    case _: routerReceive(message);
                }
            case _: routerReceive(message);
        }
    }

    public function routerReceive(message : EnumValue) : Void {
        switch (message) {
            case _:
        }
    }
}

class NoRouter extends Router {

    public function new() {
        super();
    }
}
