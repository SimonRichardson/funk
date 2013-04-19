package funk.actors;

import funk.actors.dispatch.DeadLetterMessage;
import funk.actors.dispatch.Dispatcher;
import funk.actors.events.EventStream;
import funk.actors.Props;
import funk.Funk;
import funk.actors.ActorSystem;
import funk.actors.ActorPath;
import funk.actors.ActorRef;
import funk.actors.routing.RoundRobinRouter;
import funk.actors.routing.Routing;
import funk.types.Any.AnyTypes;
import funk.types.AnyRef;
import funk.io.logging.LogLevel;
import funk.io.logging.LogValue;

using funk.types.Option;
using funk.collections.immutable.List;

interface ActorRefProvider {

    function init(system : ActorSystem) : Void;

    function rootPath() : ActorPath;

    function guardian() : ActorRef;

    function systemGuardian() : ActorRef;

    function deadLetters() : ActorRef;

    function actorOf(   system : ActorSystem,
                        props : Props,
                        supervisor : InternalActorRef,
                        path : ActorPath) : InternalActorRef;

    function actorFor(path : ActorPath) : Option<ActorRef>;

    function eventStream() : EventStream;

    function settings() : Settings;
}

interface ActorRefFactory {

    function actorOf(props : Props, name : String) : ActorRef;

    function actorFor(path : ActorPath) : Option<ActorRef>;
}

enum LocalActorMessage {
    CreateChild(props : Props, name : String);
}

class Settings {

    private var _serializeAllMessages : Bool;

    public function new(serializeAllMessages : Bool = false) {
        _serializeAllMessages = serializeAllMessages;
    }

    public function serializeAllMessages() : Bool return _serializeAllMessages;
}

class LocalActorRefProvider implements ActorRefProvider {

    private var _system : ActorSystem;

    private var _rootPath : ActorPath;

    private var _rootGuardian : InternalActorRef;

    private var _guardian : InternalActorRef;

    private var _systemGuardian : InternalActorRef;

    private var _deadLetters : InternalActorRef;

    private var _eventStream : EventStream;

    private var _settings : Settings;

    public function new(?settings : Settings = null) {
        _settings = AnyTypes.toBool(settings) ? settings : new Settings();
    }

    public function init(system : ActorSystem) : Void {
        _system = system;

        _eventStream = new EventStream();

        _rootPath = new RootActorPath(Address("funk", system.name(), None, None));

        var rootActorPath = _rootPath;
        var guardianActorPath = rootActorPath.child("user");
        var systemActorPath = rootActorPath.child("system");
        var deadLettersActorPath = rootActorPath.child("deadLetters");

        var guardianProps = new Props(Guardian);
        var systemProps = new Props(SystemGuardian);
        var deadLettersProps = new Props(DeadLetters);

        _rootGuardian = new RootGuardianActorRef(this, rootActorPath);

        var rootGuardian = new LocalActorRef(system, guardianProps, _rootGuardian, rootActorPath);

        var rootCell = rootGuardian.underlying();
        rootCell.reserveChild(guardianActorPath.name());
        rootCell.reserveChild(systemActorPath.name());
        rootCell.reserveChild(deadLettersActorPath.name());

        _deadLetters = actorOf(system, deadLettersProps, rootGuardian, deadLettersActorPath);
        rootCell.initChild(_deadLetters);
        _deadLetters.start();

        _guardian = actorOf(system, guardianProps, rootGuardian, guardianActorPath);
        rootCell.initChild(_guardian);
        _guardian.start();

        _systemGuardian = actorOf(system, systemProps, rootGuardian, systemActorPath);
        rootCell.initChild(_systemGuardian);
        _systemGuardian.start();

        rootGuardian.start();

        // We don't have an option to do this earlier as we're waiting for the system guardian.
        _eventStream.setupDefaultLoggers(system, Debug(Data({})));
    }

    public function rootPath() : ActorPath return _guardian.path();

    public function guardian() : ActorRef return _guardian;

    public function systemGuardian() : ActorRef return _systemGuardian;

    public function deadLetters() : ActorRef return _deadLetters;

    public function eventStream() : EventStream return _eventStream;

    public function settings() : Settings return _settings;

    public function actorOf(    system : ActorSystem,
                                props : Props,
                                supervisor : InternalActorRef,
                                path : ActorPath) : InternalActorRef {
        var router = props.router();
        return switch(router) {
            case _ if(AnyTypes.isInstanceOf(router, NoRouter)): new LocalActorRef(system, props, supervisor, path);
            case _:
                // TODO (Simon) : Work out if we need to fall-back onto a router if we can't locate it.
                // TODO (Simon) : Make this configurable
                //var nrOfInstances = 2;
                //var routedProps = props.withRouter(new RoundRobinRouter(nrOfInstances));
                new RoutedActorRef(system, props, supervisor, path);
        }
    }

    public function actorFor(path : ActorPath) : Option<ActorRef> {
        return switch(path) {
            case _ if(AnyTypes.isInstanceOf(path, RelativeActorPath)):
                var relative : RelativeActorPath = cast path;
                switch(relative.name()) {
                    case '/': actorFrom(_rootGuardian, path.elements());
                    case _: Some(deadLetters());
                }
            case _ if(path.root() == _rootPath): actorFrom(_rootGuardian, path.elements());
            case _: Some(deadLetters());
        }
    }

    @:allow(funk.actors)
    private function actorFrom(ref : InternalActorRef, elements : List<String>) : Option<ActorRef> {
        return if (elements.isEmpty()) Some(deadLetters());
        else {
            var x = ref.getChild(elements);
            switch(x) {
                case None:
                    var empty : ActorRef = new EmptyActorRef(_system.provider(), ref.path().childs(elements));
                    Some(empty);
                case _: cast x;
            }
        }
    }

    public function toString() return '[ActorRefProvider (path=${_rootPath.toString()})]';
}

class RootGuardianActorRef extends EmptyActorRef {

    public function new(provider : ActorRefProvider, path : ActorPath) {
        super(provider, path);
    }

    override public function getChild(names : List<String>) : Option<InternalActorRef> {
        if (!AnyTypes.isInstanceOf(_provider, LocalActorRefProvider)) {
            Funk.error(IllegalOperationError());
        }

        var local : LocalActorRefProvider = cast _provider;
        return switch(names.head()) {
            case "deadLetters": Some(cast local.deadLetters());
            case "user":
                if (names.tail().isEmpty()) Some(cast local.guardian());
                else cast local.actorFrom(cast local.guardian(), names.tail());
            case "system": 
                if (names.tail().isEmpty()) Some(cast local.systemGuardian());
                else cast local.actorFrom(cast local.systemGuardian(), names.tail());
            case _: None;
        }
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
            case _ if(AnyTypes.isInstanceOf(value, LocalActorMessage)):
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

    override public function preRestart(reason : Errors, message : Option<AnyRef>) : Void {}
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

    override public function preRestart(reason : Errors, message : Option<AnyRef>) : Void {}
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
            case _ if(value == DeadLetterMessage): eventStream.publish(value);
            case _:
                var s = sender();
                var receiver : Option<ActorRef> = cast cxt.self().toOption();
                var origin : Option<ActorRef> = AnyTypes.toBool(s) ? s : receiver;
                eventStream.publish(DeadLetter(value, origin, receiver));
        }
    }
}
