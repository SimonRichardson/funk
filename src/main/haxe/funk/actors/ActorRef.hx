package funk.actors;

import funk.actors.ActorCell;
import funk.actors.ActorSystem;
import funk.actors.dispatch.EnvelopeMessage;
import funk.actors.dispatch.SystemMessage;
import funk.actors.Props;
import funk.Funk;
import funk.types.Any.AnyTypes;
import funk.types.extensions.Strings;

using funk.futures.Promise;
using funk.types.AnyRef;
using funk.types.Option;
using funk.collections.immutable.List;

interface ActorRef {

    function name() : String;

    function path() : ActorPath;

    function send(msg : AnyRef, ?sender : ActorRef = null) : Void;

    function actorOf(props : Props, name : String) : ActorRef;

    function actorFor(path : ActorPath) : Option<ActorRef>;

    function context() : ActorContext;
}

interface InternalActorRef extends ActorRef {

    function start() : Void;

    function stop() : Void;

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

    public function start() : Void _actorCell.start();

    public function stop() : Void _actorCell.stop();

    public function actorOf(props : Props, name : String) : ActorRef return _actorCell.actorOf(props, name);

    public function actorFor(path : ActorPath) : Option<ActorRef> return _actorCell.actorFor(path);

    public function send(msg : AnyRef, ?sender : ActorRef = null) : Void {
        var s = AnyTypes.toBool(sender) ? sender : this;
        _actorCell.sendMessage(Envelope(msg, s));
    }

    public function sendSystemMessage(message : SystemMessage) : Void _actorCell.sendSystemMessage(message);

    public function path() : ActorPath return _path;

    public function name() : String return path().name();

    public function context() : ActorContext return _actorContext;

    public function getParent() : InternalActorRef return _actorCell.parent();

    public function getChild(names : List<String>) : Option<InternalActorRef> {
        function rec(ref : InternalActorRef, names : Iterator<String>) : Option<InternalActorRef> {
            return switch(ref) {
                case _ if(Std.is(ref, LocalActorRef)):
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
            case Some(ChildRestartStats(val)) if(Std.is(val, InternalActorRef)): Some(cast val);
            case _: None;
        }
    }

    @:allow(funk.actors)
    @:allow(funk.actors.patterns)
    private function underlying() : ActorCell return cast _actorCell;

    private function newCell() : Cell return new ActorCell(_system, this, _props, _supervisor);

    private function initCell() : Void _actorCell.init(Strings.uuid());

    public function toString() return '[ActorRef (path=${path()})]';
}

class EmptyActorRef implements InternalActorRef {

    private var _provider : ActorRefProvider;

    private var _path : ActorPath;

    public function new(provider : ActorRefProvider, path : ActorPath) {
        _provider = provider;
        _path = path;
    }

    public function start() : Void {}

    public function stop() : Void {}

    public function send(msg : AnyRef, ?sender : ActorRef = null) : Void {}

    public function sendSystemMessage(message : SystemMessage) : Void {}

    public function actorOf(props : Props, name : String) : ActorRef return null;

    public function actorFor(path : ActorPath) : Option<ActorRef> return None;

    public function path() : ActorPath return _path;

    public function name() : String return path().name();

    public function sender() : ActorRef return null;

    public function context() : ActorContext return null;

    public function getParent() : InternalActorRef return null;

    public function getChild(names : List<String>) : Option<InternalActorRef> return None;
}
