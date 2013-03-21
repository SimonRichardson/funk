package funk.actors;

import funk.actors.Props;
import funk.Funk;
import funk.actors.ActorSystem;
import funk.actors.ActorPath;
import funk.actors.ActorRef;
import funk.actors.routing.Routing;
import funk.types.AnyRef;

using funk.types.Option;

interface ActorRefProvider {

    function init(system : ActorSystem) : Void;

    function rootPath() : ActorPath;

    function guardian() : ActorRef;
}

interface ActorRefFactory {

    function actorOf(props : Props, name : String) : ActorRef;
}

enum LocalActorMessage {
    CreateChild(props : Props, name : String);
}

class LocalActorRefProvider implements ActorRefProvider {

    private var _rootGuardian : ActorRef;

    private var _guardian : ActorRef;

    private var _systemGuardian : ActorRef;

    public function new() {
    }

    public function init(system : ActorSystem) : Void {
        var rootActorPath = new RootActorPath(Address("funk", system.name(), None, None));
        var guardianActorPath = rootActorPath.child("user");
        var systemActorPath = rootActorPath.child("system");

        var guardianProps = new Props(Guardian);
        var systemProps = new Props(SystemGuardian);

        var rootRef = new RootGuardianActorRef(this, rootActorPath);

        _rootGuardian = new InternalActorRef(system, guardianProps, rootRef, rootActorPath);
        _guardian = actorOf(system, guardianProps, _rootGuardian, guardianActorPath);
        _systemGuardian = actorOf(system, systemProps, _rootGuardian, systemActorPath);
    }

    public function rootPath() : ActorPath return _guardian.path();

    public function guardian() : ActorRef return _guardian;

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

    override public function receive(value : AnyRef) : Void {
        switch(value) {
            case _ if(Std.is(value, LocalActorMessage)):
                var local : LocalActorMessage = cast value;
                switch(local) {
                    case CreateChild(props, name):
                        var s = sender();
                        s.send(context().actorOf(props, name), s);
                }
        }
    }
}

class SystemGuardian extends Actor {

    public function new() {
        super();
    }
}
