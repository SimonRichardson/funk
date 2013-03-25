package funk.actors;

import funk.actors.dispatch.Dispatcher;
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

    function actorOf(   system : ActorSystem,
                        props : Props,
                        supervisor : InternalActorRef,
                        path : ActorPath) : InternalActorRef;
}

interface ActorRefFactory {

    function actorOf(props : Props, name : String) : ActorRef;
}

enum LocalActorMessage {
    CreateChild(props : Props, name : String);
}

class LocalActorRefProvider implements ActorRefProvider {

    private var _system : ActorSystem;

    private var _rootGuardian : InternalActorRef;

    private var _guardian : ActorRef;

    private var _systemGuardian : ActorRef;

    public function new() {
    }

    public function init(system : ActorSystem) : Void {
        _system = system;

        var rootActorPath = new RootActorPath(Address("funk", system.name(), None, None));
        var guardianActorPath = rootActorPath.child("user");
        var systemActorPath = rootActorPath.child("system");

        var guardianProps = new Props(Guardian);
        var systemProps = new Props(SystemGuardian);

        var rootRef = new RootGuardianActorRef(this, rootActorPath);

        _rootGuardian = new LocalActorRef(system, guardianProps, rootRef, rootActorPath);
        _guardian = actorOf(system, guardianProps, _rootGuardian, guardianActorPath);
        _systemGuardian = actorOf(system, systemProps, _rootGuardian, systemActorPath);
    }

    public function rootPath() : ActorPath return _guardian.path();

    public function guardian() : ActorRef return _guardian;

    public function actorOf(   system : ActorSystem,
                                props : Props,
                                supervisor : InternalActorRef,
                                path : ActorPath) : InternalActorRef {
        var router = props.router();
        return switch(router) {
            case _ if(Std.is(router, NoRouter)): new LocalActorRef(system, props, supervisor, path);
            case _: Funk.error(ActorError("Missing implementation around routers"));
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
                        switch(sender()) {
                            case Some(s): s.send(context().actorOf(props, name), s);
                            case _:
                        }
                }
        }
    }
}

class SystemGuardian extends Actor {

    public function new() {
        super();
    }
}
