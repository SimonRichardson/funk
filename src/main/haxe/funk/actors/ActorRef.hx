package funk.actors;

import funk.actors.ActorSystem;
import funk.actors.dispatch.SystemMessage;
import funk.actors.Props;
import funk.Funk;

using funk.futures.Promise;
using funk.types.AnyRef;
using funk.types.Option;

interface ActorRef {

    function name() : String;

    function path() : ActorPath;

    function send(msg : AnyRef, sender : ActorRef) : Void;

    function actorOf(props : Props, name : String) : ActorRef;

    function context() : ActorContext;
}

interface InternalActorRef extends ActorRef {

    function start() : Void;

    function sendSystemMessage(message : SystemMessage) : Void;
}

class LocalActorRef implements InternalActorRef {

    private var _system : ActorSystem;

    private var _props : Props;

    private var _supervisor : InternalActorRef;

    private var _path : ActorPath;

    private var _actorCell : ActorCell;

    private var _actorContext : ActorContext;

    public function new(system : ActorSystem, props : Props, supervisor : InternalActorRef, path : ActorPath) {
        _system = system;
        _props = props;
        _supervisor = supervisor;
        _path = path;

        _actorCell = new ActorCell(system, this, props, supervisor);
        _actorContext = _actorCell;

        _actorCell.init(ActorSystem.UniqueId);
    }

    public function start() : Void _actorCell.start();

    public function send(msg : AnyRef, sender : ActorRef) : Void _actorCell.send(msg, sender);

    public function actorOf(props : Props, name : String) : ActorRef {
        return null;
    }

    public function sendSystemMessage(message : SystemMessage) : Void _actorCell.sendSystemMessage(message);

    public function path() : ActorPath return _path;

    public function name() : String return path().name();

    public function context() : ActorContext return _actorContext;
}

class EmptyActorRef implements InternalActorRef {

    private var _provider : ActorRefProvider;

    private var _path : ActorPath;

    public function new(provider : ActorRefProvider, path : ActorPath) {
        _provider = provider;
        _path = path;
    }

    public function start() : Void {

    }

    public function send(msg : AnyRef, sender : ActorRef) : Void {

    }

    public function sendSystemMessage(message : SystemMessage) : Void {

    }

    public function actorOf(props : Props, name : String) : ActorRef {
        return null;
    }

    public function path() : ActorPath return _path;

    public function name() : String return path().name();

    public function sender() : ActorRef return null;

    public function context() : ActorContext return null;
}
