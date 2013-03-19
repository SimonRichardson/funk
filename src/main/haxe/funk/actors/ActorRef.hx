package funk.actors;

import funk.Funk;

using funk.actors.ActorSystem;
using funk.actors.ActorCell;
using funk.actors.ActorSystem;
using funk.actors.event.EventStream;
using funk.futures.Promise;
using funk.types.AnyRef;
using funk.types.Function1;
using funk.types.Option;
using funk.collections.immutable.List;

typedef ActorRef = {

    function name() : String;

    function path() : ActorPath;

    function tell(msg : EnumValue, sender : ActorRef) : Void;

    function forward(message : EnumValue) : Function1<ActorContext, Void>;

    function isTerminated(): Bool;
}

enum DeadLetter {
    DeadLetter(message : AnyRef, sender : ActorRef, recipient : ActorRef);
}

class InternalActorRef {

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

    public function ask(reciever : ActorRef, message : EnumValue) : Promise<EnumValue> {
        return null;
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

    public function resume() : Void _actorCell.resume();

    public function restart(cause : Errors) : Void _actorCell.restart(cause);

    public function stop() : Void _actorCell.stop();

    public function parent() : ActorRef return _actorCell.parent();

    public function provider() return _actorCell.provider();

    public function system() : ActorSystem return _actorCell.system();

    public function isTerminated() : Bool return _isTerminated;

    public function context() : ActorContext return _actorCell;

    public function cell() : ActorCell return _actorCell;

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

class EmptyActorRef extends InternalActorRef {

    private var _eventStream : EventStream;

    public function new(provider : ActorRefProvider, path : ActorPath, eventStream : EventStream) {
        super(provider, props, supervisor, path);

        _eventStream = eventStream;
    }

    override public function tell(message : EnumValue, sender : ActorRef) : Void {
        switch(message) {
            case DeadLetter:
            case _: eventStream().publish(DeadLetter(message, sender, this));
        }
    }

    override public function isTerminated() : Bool return true;

    public function eventStream() : EventStream return _eventStream;
}

class DeadLetterActorRef extends EmptyActorRef {

    public function new(provider : ActorRefProvider, path : ActorPath, eventStream : EventStream) {
        super(provider, path, eventStream);
    }

    override public function tell(message : EnumValue, sender : ActorRef) : Void {
        switch(sender) {
            case DeadLetter: eventStream().publish(message);
            case _: eventStream().publish(DeadLetter(message, sender, this));
        }
    }
}

