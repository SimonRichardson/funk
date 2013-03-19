package funk.actors;

import funk.Funk;

using funk.actors.dispatch.MessageDispatcher;
using funk.actors.event.EventStream;
using funk.actors.routing.Routing;
using funk.actors.Actor;
using funk.actors.ActorPath;
using funk.actors.ActorSystem;
using funk.types.AnyRef;
using funk.types.Option;
using funk.futures.Deferred;
using funk.futures.Promise;
using funk.types.Unit;

typedef ActorRefProvider = {

    function init(system : ActorSystem) : ActorRefProvider;

    function rootGuardian() : InternalActorRef;

    function guardian() : InternalActorRef;

    function systemGuardian() : InternalActorRef;

    function deadLetters() : ActorRef;

    function rootPath() : ActorPath;

    function dispatcher() : MessageDispatcher;

    function scheduler() : Scheduler;

    function eventStream() : EventStream;

    function actorOf(   system: ActorSystem,
                        props: Props,
                        supervisor: InternalActorRef,
                        path: ActorPath
                        ) : InternalActorRef;

    function terminationFuture() : Promise<Unit>;
}

enum LocalActorMessage {
    CreateChild(props : Props, name : String);
    StopChild(child : ActorRef);
}

class LocalActorRefProvider {

    private var _system : ActorSystem;

    private var _systemName : String;

    private var _rootPath : ActorPath;

    private var _deadLetters : ActorRef;

    private var _scheduler : Scheduler;

    private var _rootGuardian : InternalActorRef;

    private var _guardian : InternalActorRef;

    private var _systemGuardian : InternalActorRef;

    private var _terminationDeferred : Deferred<Unit>;

    public function new(systemName : String, eventStream : EventStream, scheduler : Scheduler) {
        _systemName = systemName;
        _scheduler = scheduler;

        _terminationDeferred = new Deferred();

        _rootPath = new RootActorPath(Address("funk", _systemName, None, None));
        _deadLetters = new DeadLetterActorRef(this, _rootPath.child("deadLetters"), eventStream);

        var rootProps = new Props(Guadian);
        var systemProps = new Props(SystemGuadian);

        _rootGuardian = new LocalActorRef(_system, rootProps, rootPath);
        _guardian = actorOf(_system, props, _rootGuardian, rootPath.child("user"));
        _systemGuardian = actorOf(_system, systemProps, _rootGuardian, rootPath.child("system"));
    }

    public function init(system : ActorSystem) : ActorRefProvider {
        _system = system;

        return this;
    }

    public function actorOf(    system : ActorSystem,
                                props : Props,
                                supervisor : InternalActorRef,
                                path : ActorPath
                                ) : InternalActorRef {
        switch(props.router) {
            case _ if(Std.is(props.router, NoRouter)): new LocalActorRef(system, props, supervisor, path);
            case _:
        }
    }

    public function rootGuardian() : InternalActorRef return _rootGuardian;

    public function guardian() : InternalActorRef return _guardian;

    public function systemGuardian() : InternalActorRef return _systemGuardian;

    public function deadLetters() : ActorRef return _deadLetters;

    public function rootPath() : ActorPath return _rootPath;

    public function dispatcher() : MessageDispatcher return _system.dispatcher();

    public function scheduler() : Scheduler return _system.scheduler();

    public function eventStream() : EventStream return _eventStream;

    public function terminationFuture() : Promise<Unit> return _terminationDeferred.promise();
}

class Guadian extends Actor {

    public function new() {
        super();
    }

    override public function receive(message : EnumValue) : Void {
        function forward(message : EnumValue) {
            deadLetters().tell(message, sender(), self());
        }

        switch(Type.getEnum(message)) {
            case LocalActorMessage:
                switch(cast message) {
                    case CreateChild(child, name): sender().tell(context.actorOf(child, name));
                    case StopChild(child): context().stop(child); sender().tell("ok");
                }
            case ActorMessage:
                switch(cast message) {
                    case Terminated(_): context().stop(self);
                    case _: forward(message);
                }
            case _: forward(message);
        }
    }

    override public function preRestart(cause : Errors, message : Option<AnyRef>) : Void {}
}

class SystemGuadian extends Actor {

    public function new() {
        super();
    }

    override public function receive(message : EnumValue) : Void {
        function forward(message : EnumValue) {
            deadLetters().tell(message, sender(), self());
        }

        switch(Type.getEnum(message)) {
            case LocalActorMessage:
                switch(cast message) {
                    case CreateChild(child, name): sender().tell(context.actorOf(child, name));
                    case StopChild(child): context().stop(child); sender().tell("ok");
                }
            case ActorMessage:
                switch(cast message) {
                    case Terminated(_): context().stop(self);
                    case _: forward(message);
                }
            case _: forward(message);
        }
    }

    override public function preRestart(cause : Errors, message : Option<AnyRef>) : Void {}
}
