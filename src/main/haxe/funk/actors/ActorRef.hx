package funk.actors;

import funk.actors.ActorSystem;
import funk.actors.Props;
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

    function sender() : ActorRef;

    function context() : ActorContext;
}

class InternalActorRef implements ActorRef {

    private var _system : ActorSystem;

    private var _props : Props;

    private var _supervisor : ActorRef;

    private var _path : ActorPath;

    public function new(system : ActorSystem, props : Props, supervisor : ActorRef, path : ActorPath) {
        _system = system;
        _props = props;
        _supervisor = supervisor;
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

    public function sender() : ActorRef return null;

    public function context() : ActorContext return null;
}

class EmptyActorRef implements ActorRef {

    private var _provider : ActorRefProvider;

    private var _path : ActorPath;

    public function new(provider : ActorRefProvider, path : ActorPath) {
        _provider = provider;
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

    public function sender() : ActorRef return null;

    public function context() : ActorContext return null;
}
