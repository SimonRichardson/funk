package funk.actors.patterns;

import funk.actors.ActorRef;
import funk.types.AnyRef;

using funk.futures.Promise;

class AskSupport {

    public static function ask( actor : ActorRef, 
                                value : AnyRef, 
                                sender : ActorRef) : Promise<AnyRef> {
        return PromiseTypes.empty();
    }
}

class PromiseActorRef {

    public function new() {

    }

    public function ask(value : AnyRef, sender : ActorRef) : Promise<AnyRef> {
        return PromiseTypes.empty();
    }
}
