package funk.actors;

import funk.actors.Actor;
import funk.actors.Props;
import funk.types.Pass;

class UntypedActor extends Actor {

    public function new() {
        super();
    }
}

class UntypedActorFactory implements Creator {

    public function new() {}

    public function create() : Actor return Pass.instanceOf(UntypedActor)();
}
