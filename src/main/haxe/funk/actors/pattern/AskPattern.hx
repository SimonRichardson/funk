package funk.actors.patterns;

import funk.actors.ActorRef;
import funk.types.AnyRef;

using funk.futures.Promise;

interface AskSupport {

    function ask(value : AnyRef, sender : ActorRef) : Promise<AnyRef>;
}

class PromiseActorRef implements AskSupport {

    public function new() {

    }

    public function ask(value : AnyRef, sender : ActorRef) : Promise<AnyRef> {
        return PromiseTypes.empty();
    }
}
