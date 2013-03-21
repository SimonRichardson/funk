package funk.actors;

import funk.actors.Props;
import funk.Funk;
import funk.actors.ActorSystem;
import funk.actors.ActorPath;
import funk.actors.ActorRef;
import funk.actors.routing.Routing;

using funk.types.Option;

interface ActorRefProvider {

    function init(system : ActorSystem) : Void;

    function rootPath() : ActorPath;

    function guardian() : ActorRef;
}

enum LocalActorMessage {
    CreateChild(props : Props, name : String);
}

class LocalActorRefProvider implements ActorRefProvider {

    private var _rootActor : ActorRef;

    private var _guardianActor : ActorRef;

    private var _systemActor : ActorRef;

    public function new() {
    }

    public function init(system : ActorSystem) : Void {
        var rootActorPath = new RootActorPath(Address("funk", system.name(), None, None));
        var guardianActorPath = rootActorPath.child("user");
        var systemActorPath = rootActorPath.child("system");

        var guardianProps = new Props(Guardian);
        var systemProps = new Props(SystemGuardian);

        _rootActor = new RootGuardianActorRef(this, rootActorPath);

        _guardianActor = actorOf(system, guardianProps, _rootActor, guardianActorPath);
        _systemActor = actorOf(system, systemProps, _rootActor, systemActorPath);
    }

    public function rootPath() : ActorPath return _rootActor.path();

    public function guardian() : ActorRef return _guardianActor;

    private function actorOf(   system : ActorSystem,
                                props : Props,
                                supervisor : ActorRef,
                                path : ActorPath) : ActorRef {
        var router = props.router();
        return switch(router) {
            case _ if(Std.is(router, NoRouter)): new InternalActorRef(system, props, supervisor, path);
            case _: null;
        }
    }
}

class RootGuardianActorRef extends EmptyActorRef {

    public function new(provider : ActorRefProvider, path : ActorPath) {
        super(provider, path);
    }
}

class Guardian extends Actor {

    public function new() {
        super();
    }
}

class SystemGuardian extends Actor {

    public function new() {
        super();
    }
}
