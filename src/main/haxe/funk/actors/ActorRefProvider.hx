package funk.actors;

import funk.actors.dispatch.DeadLetterMessage;
import funk.actors.dispatch.Dispatcher;
import funk.actors.event.EventStream;
import funk.actors.Props;
import funk.Funk;
import funk.actors.ActorSystem;
import funk.actors.ActorPath;
import funk.actors.ActorRef;
import funk.actors.routing.Routing;
import funk.types.Any.AnyTypes;
import funk.types.AnyRef;

using funk.types.Option;

interface ActorRefProvider {

    function init(system : ActorSystem) : Void;

    function rootPath() : ActorPath;

    function guardian() : ActorRef;

    function deadLetters() : ActorRef;

    function actorOf(   system : ActorSystem,
                        props : Props,
                        supervisor : InternalActorRef,
                        path : ActorPath) : InternalActorRef;

    function actorFor(path : List<String>) : Option<ActorRef>;

    function eventStream() : EventStream;
}

interface ActorRefFactory {

    function actorOf(props : Props, name : String) : ActorRef;

    function actorFor(name : String) : Option<ActorRef>;
}

enum LocalActorMessage {
    CreateChild(props : Props, name : String);
}

class LocalActorRefProvider implements ActorRefProvider {

    private var _system : ActorSystem;

    private var _rootGuardian : InternalActorRef;

    private var _guardian : ActorRef;

    private var _systemGuardian : ActorRef;

    private var _deadLetters : ActorRef;

    private var _eventStream : EventStream;

    public function new() {
    }

    public function init(system : ActorSystem) : Void {
        _system = system;

        _eventStream = new EventStream();

        var rootActorPath = new RootActorPath(Address("funk", system.name(), None, None));
        var guardianActorPath = rootActorPath.child("user");
        var systemActorPath = rootActorPath.child("system");
        var deadLettersActorPath = rootActorPath.child("deadLetters");

        var guardianProps = new Props(Guardian);
        var systemProps = new Props(SystemGuardian);
        var deadLettersProps = new Props(DeadLetters);

        var rootRef = new RootGuardianActorRef(this, rootActorPath);

        _rootGuardian = new LocalActorRef(system, guardianProps, rootRef, rootActorPath);

        _deadLetters = actorOf(system, deadLettersProps, _rootGuardian, deadLettersActorPath);

        _guardian = actorOf(system, guardianProps, _rootGuardian, guardianActorPath);
        _systemGuardian = actorOf(system, systemProps, _rootGuardian, systemActorPath);
    }

    public function rootPath() : ActorPath return _guardian.path();

    public function guardian() : ActorRef return _guardian;

    public function deadLetters() : ActorRef return _deadLetters;

    public function eventStream() : EventStream return _eventStream;

    public function actorOf(    system : ActorSystem,
                                props : Props,
                                supervisor : InternalActorRef,
                                path : ActorPath) : InternalActorRef {
        var router = props.router();
        return switch(router) {
            case _ if(Std.is(router, NoRouter)): new LocalActorRef(system, props, supervisor, path);
            case _: Funk.error(ActorError("Missing implementation around routers"));
        }
    }

    public function actorFor(path : List<String>) : Option<ActorRef> {
        return None;
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
        var cxt = context();

        function forwardToDeadLetters(letter : DeadLetterMessage) {
            var letters = cxt.system().deadLetters();
            letters.send(letter, letters);
        }
        
        switch(value) {
            case _ if(Std.is(value, LocalActorMessage)):
                var local : LocalActorMessage = cast value;
                switch(local) {
                    case CreateChild(props, name):
                        switch(sender()) {
                            case Some(s): s.send(cxt.actorOf(props, name), s);
                            case _: 
                                var receiver : Option<ActorRef> = cast cxt.self().toOption();
                                forwardToDeadLetters(DeadLetter(value, sender(), receiver));
                        }
                }
            case _: 
                var receiver : Option<ActorRef> = cast cxt.self().toOption();
                forwardToDeadLetters(DeadLetter(value, sender(), receiver));
        }
    }
}

class SystemGuardian extends Actor {

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {
        var cxt = context();

        function forwardToDeadLetters(letter : DeadLetterMessage) {
            var letters = cxt.system().deadLetters();
            letters.send(letter, letters);
        }
        
        switch(value) {
            case _: 
                var receiver : Option<ActorRef> = cast cxt.self().toOption();
                forwardToDeadLetters(DeadLetter(value, sender(), receiver));
        }
    }
}

class DeadLetters extends Actor {

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {
        var cxt = context();
        var eventStream = cxt.system().eventStream();

        switch(value) {
            case _ if(value == null): Funk.error(ActorError("Message is null"));
            case _ if(value == DeadLetterMessage): eventStream.dispatch(value);
            case _: 
                var s = sender();
                var receiver : Option<ActorRef> = cast cxt.self().toOption();
                var origin : Option<ActorRef> = AnyTypes.toBool(s) ? s : receiver;
                eventStream.dispatch(DeadLetter(value, origin, receiver));
        }
    }
}
