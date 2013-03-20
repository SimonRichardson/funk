package funk.actors;

import funk.Funk;

using funk.actors.ActorSystem;
using funk.actors.ActorCell;
using funk.actors.ActorSystem;
using funk.actors.dispatch.MessageDispatcher;
using funk.actors.event.EventStream;
using funk.futures.Promise;
using funk.types.AnyRef;
using funk.types.Function1;
using funk.types.Option;
using funk.collections.immutable.List;

typedef ActorRef = {

    function name() : String;

    function path() : ActorPath;

    function ask(msg : EnumValue, sender : ActorRef) : Promise<EnumValue>;

    function tell(msg : EnumValue, sender : ActorRef) : Void;

    function forward(message : EnumValue) : Function1<ActorContext, Void>;

    function isTerminated(): Bool;
}

typedef InternalActorRef = {>ActorRef,

    function cell() : ActorCell;

    function start() : Void;

    function resume(causedByFailure : Errors) : Void;

    function suspend() : Void;

    function restart(cause : Errors) : Void;

    function stop() : Void;

    function sendSystemMessage(message : SystemMessage) : Void;
}

enum DeadLetter {
    DeadLetter(message : AnyRef, sender : ActorRef, recipient : ActorRef);
}

class LocalActorRef {

    private var _actorCell : ActorCell;

    private var _actorContext : ActorContext;

    private var _system : ActorSystem;

    private var _props : Props;

    private var _supervisor : InternalActorRef;

    private var _actorPath : ActorPath;

    private var _isTerminated : Bool;

    public function new(system : ActorSystem, props : Props, supervisor : InternalActorRef, path : ActorPath) {
        _system = system;
        _props = props;
        _supervisor = supervisor;
        _actorPath = path;

        _actorCell = new ActorCell(_system, this, _props, _supervisor);
        _actorContext = _actorCell;

        _actorCell.start();
    }

    public function ask(msg : EnumValue, sender : ActorRef) : Promise<EnumValue> {
        return PromiseTypes.empty();
    }

    public function forward(message : EnumValue) : Function1<ActorContext, Void> {
        return function(context : ActorContext) {
            tell(message, context.sender());
        }
    }

    public function tell(message : EnumValue, sender : ActorRef) : Void _actorCell.tell(message, sender);

    public function name() : String return _actorPath.name();

    public function path() : ActorPath return _actorPath;

    public function suspended() : Void _actorCell.suspended();

    public function resume(causedByFailure : Errors) : Void _actorCell.resume();

    public function restart(cause : Errors) : Void _actorCell.restart(cause);

    public function start() : Void _actorCell.start();

    public function stop() : Void _actorCell.stop();

    public function suspend() : Void _actorCell.suspend();

    public function parent() : ActorRef return _actorCell.parent();

    public function provider() return _actorCell.provider();

    public function system() : ActorSystem return _actorCell.system();

    public function isTerminated() : Bool return _isTerminated;

    public function context() : ActorContext return _actorCell;

    public function cell() : ActorCell return _actorCell;

    public function sendSystemMessage(message : SystemMessage) : Void {}

    public function getChild(names : List<String>) : ActorRef {
        function rec(ref : ActorRef, name : List<String>) : ActorRef {
            return switch(ref) {
                case _ if(Std.is(ref, InternalActorRef)):
                    var n = names.head();
                    var next = switch(n) {
                        case "..": ref.parent().toOption();
                        case "": Some(ref);
                        case _: ref.getSingleChild(n).toOption();
                    }
                    if (next.isDefined() || name.isEmpty()) next;
                    else rec(next, name.tail());
                case _: ref.getChild(name);
            }
        }

        return if (names.isEmpty()) this;
        else rec(this, names);
    }

    private function getSingleChild(name : String) : Option<InternalActorRef> {
        _actorCell.childrenRefs.filter(function(value) {
            return value.name() == name;
        });
    }
}

class EmptyActorRef {

    private var _provider : ActorRefProvider;

    private var _path : ActorPath;

    private var _eventStream : EventStream;

    public function new(provider : ActorRefProvider, path : ActorPath, eventStream : EventStream) {
        _provider = provider;
        _path = path;
        _eventStream = eventStream;
    }

    public function ask(msg : EnumValue, sender : ActorRef) : Promise<EnumValue> {
        return PromiseTypes.empty();
    }

    public function tell(message : EnumValue, sender : ActorRef) : Void {
        switch(message) {
            case DeadLetter:
            case _: eventStream().publish(DeadLetter(message, sender, this));
        }
    }

    public function name() : String return _path.name();

    public function path() : ActorPath return _path;

    public function cell() : ActorCell return null;

    public function forward(message : EnumValue) : Function1<ActorContext, Void> {
        return function(context) {};
    }

    public function isTerminated() : Bool return true;

    public function eventStream() : EventStream return _eventStream;
}

class MinimalActorRef extends EmptyActorRef {

    public function new(provider : ActorRefProvider, path : ActorPath, eventStream : EventStream) {
        super(provider, path, eventStream);
    }

    public function cell() : ActorCell return null;

    public function start() : Void {
    }

    public function resume(causedByFailure : Errors) : Void {
    }

    public function suspend() : Void {
    }

    public function restart(cause : Errors) : Void {
    }

    public function stop() : Void {
    }

    public function sendSystemMessage(message : SystemMessage) : Void {
    }
}

class DeadLetterActorRef extends MinimalActorRef {

    public function new(provider : ActorRefProvider, path : ActorPath, eventStream : EventStream) {
        super(provider, path, eventStream);
    }

    override public function tell(message : EnumValue, sender : ActorRef) : Void {
        function message(message : EnumValue) {
            eventStream().publish(DeadLetter(message, sender, this), sender);
        }

        switch(message) {
            case DeadLetter:
                switch(cast message) {
                    case DeadLetter(_): eventStream().publish(message, sender);
                    case _: handle(message);
                }
            case _: handle(message);
        }
    }
}

