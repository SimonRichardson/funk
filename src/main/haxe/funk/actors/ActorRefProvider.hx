package funk.actors;

import funk.Funk;

using funk.actors.dispatch.MessageDispatcher;
using funk.actors.event.EventStream;
using funk.actors.routing.Routing;
using funk.actors.Actor;
using funk.actors.ActorPath;
using funk.actors.ActorRef;
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

    function deadLetters() : InternalActorRef;

    function rootPath() : ActorPath;

    function dispatcher() : MessageDispatcher;

    function scheduler() : Scheduler;

    function eventStream() : EventStream;

    function actorOf(   system: ActorSystem,
                        props: Props,
                        supervisor: ActorRef,
                        path: ActorPath
                        ) : InternalActorRef;

    function terminationFuture() : Promise<Unit>;
}

typedef ActorRefFactory = {

    function actorOf(props : Props, name : String) : ActorRef;

    function stop(?actor : ActorRef) : Void;
}

enum LocalActorMessage {
    CreateChild(props : Props, name : String);
    StopChild(child : ActorRef);
}

class LocalActorRefProvider {

    private var _system : ActorSystem;

    private var _systemName : String;

    private var _rootPath : ActorPath;

    private var _deadLetters : InternalActorRef;

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

        var rootRef = new RootGuardianActorRef(this, _rootPath, eventStream);

        _rootGuardian = new LocalActorRef(_system, rootProps, rootRef, _rootPath);
        _guardian = actorOf(_system, rootProps, _rootGuardian, _rootPath.child("user"));
        _systemGuardian = actorOf(_system, systemProps, _rootGuardian, _rootPath.child("system"));
    }

    public function init(system : ActorSystem) : ActorRefProvider {
        _system = system;

        return this;
    }

    public function actorOf(    system : ActorSystem,
                                props : Props,
                                supervisor : ActorRef,
                                path : ActorPath
                                ) : InternalActorRef {
        return switch(props.router) {
            case _ if(Std.is(props.router, NoRouter)): new LocalActorRef(system, props, cast supervisor, path);
            case _: Funk.error(ActorError("Missing implementation around routers"));
        }
    }

    public function rootGuardian() : InternalActorRef return _rootGuardian;

    public function guardian() : InternalActorRef return _guardian;

    public function systemGuardian() : InternalActorRef return _systemGuardian;

    public function deadLetters() : InternalActorRef return _deadLetters;

    public function rootPath() : ActorPath return _rootPath;

    public function dispatcher() : MessageDispatcher return _system.dispatcher();

    public function scheduler() : Scheduler return _system.scheduler();

    public function eventStream() : EventStream return _system.eventStream();

    public function terminationFuture() : Promise<Unit> return _terminationDeferred.promise();
}

class RootGuardianActorRef extends MinimalActorRef {

    public function new(provider : ActorRefProvider, path : ActorPath, eventStream : EventStream) {
        super(provider, path, eventStream);
    }
}

class Guadian extends Actor {

    public function new() {
        super();
    }

    override public function receive(message : EnumValue) : Void {
        function forward(message : EnumValue) {
            //deadLetters().tell(message, sender(), self());
        }

        switch(Type.getEnum(message)) {
            case LocalActorMessage:
                switch(cast message) {
                    case CreateChild(child, name): 
                        var s = sender();
                        s.tell(ChildCreated(cast context().actorOf(child, name)), s);
                    case StopChild(child): 
                        var s = sender();
                        context().stop(child); s.tell(Message("ok"), s);
                }
            case ActorMessage:
                switch(cast message) {
                    case Terminated(_): context().stop(self());
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
            //deadLetters().tell(message, sender(), self());
        }

        switch(Type.getEnum(message)) {
            case LocalActorMessage:
                switch(cast message) {
                    case CreateChild(child, name): 
                        var s = sender();
                        s.tell(ChildCreated(cast context().actorOf(child, name)), s);
                    case StopChild(child): 
                        var s = sender();
                        context().stop(child); s.tell(Message("ok"), s);
                }
            case ActorMessage:
                switch(cast message) {
                    case Terminated(_): context().stop(self());
                    case _: forward(message);
                }
            case _: forward(message);
        }
    }

    override public function preRestart(cause : Errors, message : Option<AnyRef>) : Void {}
}
