package funk.actors;

import funk.actors.ActorCell;
import funk.actors.ActorSystem;
import funk.actors.dispatch.EnvelopeMessage;
import funk.actors.dispatch.SystemMessage;
import funk.actors.Props;
import funk.Funk;
import funk.types.Any;
import funk.types.extensions.Strings;

using funk.futures.Promise;
using funk.types.Option;
using funk.ds.immutable.List;

interface ActorRef {

    function uid() : String;

    function name() : String;

    function path() : ActorPath;

    function send(msg : AnyRef, ?sender : ActorRef = null) : Void;

    function actorOf(props : Props, name : String) : ActorRef;

    function actorFor(path : ActorPath) : Option<ActorRef>;

    function context() : ActorContext;

    function isTerminated() : Bool;
}

interface InternalActorRef extends ActorRef {

    function start() : Void;

    function stop() : Void;

    function suspend() : Void;

    function resume(causedByFailure : Dynamic) : Void;

    function restart(cause : Dynamic) : Void;

    function sendSystemMessage(message : SystemMessage) : Void;

    function getChild(name : List<String>) : Option<InternalActorRef>;

    function getParent() : InternalActorRef;
}

class LocalActorRef implements InternalActorRef {

    private var _uid : String;

    private var _system : ActorSystem;

    private var _props : Props;

    private var _supervisor : InternalActorRef;

    private var _path : ActorPath;

    private var _actorCell : Cell;

    private var _actorContext : ActorContext;

    public function new(system : ActorSystem, props : Props, supervisor : InternalActorRef, path : ActorPath) {
        _system = system;
        _props = props;
        _supervisor = supervisor;
        _path = path;

        _uid = Strings.uuid();

        var cell = newCell();

        _actorCell = cell;
        _actorContext = cell;

        initCell();
    }

    inline public function start() : Void _actorCell.start();

    inline public function stop() : Void _actorCell.stop();

    inline public function suspend() : Void _actorCell.suspend();

    inline public function resume(causedByFailure : Dynamic) : Void _actorCell.resume(causedByFailure);

    inline public function restart(cause : Dynamic) : Void _actorCell.restart(cause);

    inline public function actorOf(props : Props, name : String) : ActorRef return _actorCell.actorOf(props, name);

    inline public function actorFor(path : ActorPath) : Option<ActorRef> return _actorCell.actorFor(path);

    inline public function send(msg : AnyRef, ?sender : ActorRef = null) : Void {
        var s = AnyTypes.toBool(sender) ? sender : this;
        _actorCell.sendMessage(Envelope(msg, s));
    }

    inline public function sendSystemMessage(message : SystemMessage) : Void _actorCell.sendSystemMessage(message);

    inline public function path() : ActorPath return _path;

    inline public function uid() : String return _uid;

    inline public function name() : String return path().name();

    inline public function context() : ActorContext return _actorContext;

    // FIXME (Simon) : This needs fixing.
    inline public function isTerminated() : Bool return false;

    inline public function getParent() : InternalActorRef return _actorCell.parent();

    public function getChild(names : List<String>) : Option<InternalActorRef> {
        function rec(ref : InternalActorRef, names : Iterator<String>) : Option<InternalActorRef> {
            return switch(ref) {
                case _ if(AnyTypes.isInstanceOf(ref, LocalActorRef)):
                    var local : LocalActorRef = cast ref;
                    var any = names.next();
                    var next : Option<InternalActorRef> = switch (any) {
                        case "..": Some(local.getParent());
                        case "": Some(ref);
                        case _: local.getSingleChild(any);
                    }

                    (!names.hasNext() || next.isEmpty()) ? next : rec(next.get(), names);

                case _: ref.getChild(Nil.appendIterator(names));
            }
        }

        return (names.isEmpty()) ? Some(cast this) : rec(this, names.iterator());
    }

    private function getSingleChild(name : String) : Option<InternalActorRef> {
        return switch(_actorCell.getChildByName(name)) {
            case Some(ChildRestartStats(val, _)) if(AnyTypes.isInstanceOf(val, InternalActorRef)): Some(cast val);
            case _: None;
        }
    }

    @:allow(funk.actors)
    @:allow(funk.actors.dispatch)
    @:allow(funk.actors.patterns)
    inline private function underlying() : ActorCell return cast _actorCell;

    private function newCell() : Cell return new ActorCell(_system, this, _props, _supervisor);

    private function initCell() : Void _actorCell.init(Strings.uuid());

    // Prevent printing out the path in the toString method as it causes massive slowdown if the path is
    // a complex one. This refers to the js.Boot.__instanceof method, causing the toString method to be called.
    public function toString() return '[ActorRef]';
}

class EmptyActorRef implements InternalActorRef {

    private var _provider : ActorRefProvider;

    private var _path : ActorPath;

    public function new(provider : ActorRefProvider, path : ActorPath) {
        _provider = provider;
        _path = path;
    }

    inline public function start() : Void {}

    inline public function stop() : Void {}

    inline public function suspend() : Void {}

    inline public function resume(causedByFailure : Dynamic) : Void {}

    inline public function restart(cause : Dynamic) : Void {}

    inline public function send(msg : AnyRef, ?sender : ActorRef = null) : Void {}

    inline public function sendSystemMessage(message : SystemMessage) : Void {}

    inline public function actorOf(props : Props, name : String) : ActorRef return null;

    inline public function actorFor(path : ActorPath) : Option<ActorRef> return None;

    inline public function path() : ActorPath return _path;

    inline public function uid() : String return '';

    inline public function name() : String return path().name();

    inline public function sender() : ActorRef return null;

    inline public function context() : ActorContext return null;

    // FIXME (Simon) : This needs fixing.
    inline public function isTerminated() : Bool return false;

    inline public function getParent() : InternalActorRef return null;

    public function getChild(names : List<String>) : Option<InternalActorRef> return None;

    inline public function toString() return '[EmptyActorRef]';
}
