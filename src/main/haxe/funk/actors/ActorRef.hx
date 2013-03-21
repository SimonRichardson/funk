package funk.actors;

import funk.Funk;

using funk.futures.Promise;
using funk.types.AnyRef;
using funk.types.Option;

interface ActorRef {

    function name() : String;

    function path() : ActorPath;

    function ask(msg : AnyRef, sender : ActorRef) : Promise<AnyRef>;

    function send(msg : AnyRef, sender : ActorRef) : Void;

    function actorOf(props : Props, name : String) : ActorRef;

    function actorFor(name : String) : ActorRef;
}

class InternalActorRef implements ActorRef {

    private var _path : ActorPath;

    public function new(path : ActorPath) {
        _path = path;
    }

    public function ask(msg : AnyRef, sender : ActorRef) : Promise<AnyRef> {
        return PromiseTypes.empty();
    }

    public function send(msg : AnyRef, sender : ActorRef) : Void {

    }

    public function actorOf(props : Props, name : String) : ActorRef {
        return null;
    }

    public function actorFor(name : String) : ActorRef {
        return null;
    }

    public function path() : ActorPath return _path;

    public function name() : String return path().name();
}
