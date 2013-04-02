package funk.actors;

import funk.actors.ActorCell;
import funk.actors.ActorSystem;
import funk.actors.dispatch.Envelope;
import funk.actors.dispatch.SystemMessage;
import funk.actors.Props;
import funk.Funk;
import funk.types.extensions.Strings;

using funk.futures.Promise;
using funk.types.AnyRef;
using funk.types.Option;

interface ActorRef {

    function name() : String;

    function path() : ActorPath;

    function send(msg : AnyRef, sender : ActorRef) : Void;

    function actorOf(props : Props, name : String) : ActorRef;

    function actorFor(name : String) : Option<ActorRef>;

    function context() : ActorContext;
}

interface InternalActorRef extends ActorRef {

    function start() : Void;

    function stop() : Void;

    function sendMessage(message : Envelope) : Void;

    function sendSystemMessage(message : SystemMessage) : Void;
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

        _actorCell.init(Strings.uuid());
    }

    public function start() : Void _actorCell.start();

    public function stop() : Void _actorCell.stop();

    public function send(msg : AnyRef, sender : ActorRef) : Void _actorCell.send(msg, sender);

    public function actorOf(props : Props, name : String) : ActorRef return _actorCell.actorOf(props, name);

    public function actorFor(name : String) : Option<ActorRef> return _actorCell.actorFor(name);

    public function sendMessage(message : Envelope) : Void _actorCell.sendMessage(message);

    public function sendSystemMessage(message : SystemMessage) : Void _actorCell.sendSystemMessage(message);

    public function path() : ActorPath return _path;

    public function name() : String return path().name();

    public function context() : ActorContext return _actorContext;

    @:allow(funk.actors)
    private function underlying() : ActorCell return cast _actorCell;

    private function newCell() : Cell return new ActorCell(_system, this, _props, _supervisor);
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

    public function send(msg : AnyRef, sender : ActorRef) : Void {}

    public function sendMessage(message : Envelope) : Void {};

    public function sendSystemMessage(message : SystemMessage) : Void {}

    public function actorOf(props : Props, name : String) : ActorRef return null;

    public function actorFor(name : String) : Option<ActorRef> return None;

    public function path() : ActorPath return _path;

    public function name() : String return path().name();

    public function sender() : ActorRef return null;

    public function context() : ActorContext return null;
}
