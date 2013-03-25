package funk.actors;

import funk.actors.dispatch.Dispatcher;
import funk.actors.dispatch.Envelope;
import funk.actors.dispatch.SystemMessage;
import funk.Funk;
import funk.actors.dispatch.Mailbox;
import funk.actors.Actor;
import funk.actors.ActorContext;
import funk.actors.ActorSystem;
import funk.actors.ActorPath;
import funk.actors.ActorRef;
import funk.actors.ActorRefProvider;
import funk.types.Any.AnyTypes;
import funk.types.AnyRef;
import haxe.ds.StringMap;

using funk.actors.dispatch.Envelope;
using funk.types.Any;
using funk.types.Option;
using funk.collections.immutable.Map;
using funk.collections.immutable.List;

class ActorCell implements ActorContext {

    private var _uid : String;

    private var _actor : Actor;

    private var _self : InternalActorRef;

    private var _system : ActorSystem;

    private var _props : Props;

    private var _parent : InternalActorRef;

    private var _children : Children;

    private var _dispatcher : Dispatcher;

    private var _currentMessage : Envelope;

    private var _mailbox : Mailbox;

    public function new(system : ActorSystem, self : InternalActorRef, props : Props, parent : InternalActorRef) {
        _system = system;
        _self = self;
        _props = props;
        _parent = parent;

        _children = new Children(this);
    }

    public function init(uid : String) : Void {
        var dispatchers = _system.dispatchers();
        _dispatcher = dispatchers.find(_props.dispatcher());

        _mailbox = _dispatcher.createMailbox(this);
        _mailbox.systemEnqueue(_self, Create(uid));

        _parent.sendSystemMessage(Supervise(_self));
    }

    public function start() : ActorContext {
        return this;
    }

    public function send(msg : AnyRef, sender : ActorRef) : Void {
        var ref = AnyTypes.toBool(sender) ? sender : null;
        _dispatcher.dispatch(this, Envelope(msg, ref));
    }

    public function actorOf(props : Props, name : String) : ActorRef return _children.actorOf(props, name);

    public function self() : InternalActorRef return _self;

    public function mailbox() : Mailbox return _mailbox;

    public function sender() : Option<ActorRef> {
        return switch (_currentMessage) {
            case _ if(_currentMessage == null): None;
            case _ if(AnyTypes.toBool(_currentMessage.sender())): Some(_currentMessage.sender());
            case _: None;
        }
    }

    public function sendSystemMessage(message : SystemMessage) : Void {
        try {
            _dispatcher.systemDispatch(this, message);
        } catch(e : Dynamic) {
            // handle
        }
    }

    public function systemInvoke(message : SystemMessage) : Void {
        switch(message) {
            case Create(uid): systemCreate(uid);
            case Supervise(cell): systemSupervise(cell);
        }
    }

    public function invoke(message : Envelope) : Void {
        _currentMessage = message;
        var msg : AnyRef = message.message();
        switch(msg) {
            case _ if(Std.is(msg, Enum)): autoReceiveMessage(message);
            case _: receiveMessage(msg);
        }
        _currentMessage = null;
    }

    private function autoReceiveMessage(message : Envelope) : Void {

    }

    private function receiveMessage(message : AnyRef) : Void {
        // TODO (Simon) : Implement behaviors.
        _actor.receive(message);
    }

    private function newActor() : Actor {
        ActorContextInjector.pushContext(this);

        var instance = null;
        try {
            var creator = _props.creator();
            instance = creator();
            if (!AnyTypes.toBool(instance)) {
                Funk.error(ActorError("Actor instance passed to actorOf can't be 'null'"));
            }
        } catch(e : Dynamic) {
            throw e;
        }

        ActorContextInjector.popContext();

        return instance;
    }

    private function systemCreate(uid : String) : Void {
        this._uid = uid;

        try {
            _actor = newActor();
            _actor.preStart();
        } catch (e : Dynamic) {
            throw e;
        }
    }

    private function systemSupervise(child : ActorRef) : Void {
        switch(_children.initChild(child)) {
            case Some(_): // TODO
            case _: Funk.error(ActorError('received Supervise from unregistered child $child, this will not end well'));
        }
    }

    @:allow(funk.actors)
    private function system() : ActorSystem return _system;

    @:allow(funk.actors)
    private function provider() : ActorRefProvider return _system.provider();

    @:allow(funk.actors)
    private function dispatcher() : Dispatcher return _dispatcher;
}


private class Children {

    private var _cell : ActorCell;

    private var _container : ChildrenContainer;

    public function new(cell : ActorCell) {
        _cell = cell;

        _container = new NormalChildrenContainer(Empty);
    }

    public function initChild(ref : ActorRef) : Option<ActorRef> {
        var name = ref.path().name();
        var opt = _container.getByName(name);
        return switch(opt) {
            case Some(ChildRestartStats(value)): Some(value);
            case Some(ChildNameReserved): _container = _container.add(name, ref); Some(ref);
            case _: None;
        }
    }

    public function actorOf(props : Props, name : String) : ActorRef return makeChild(_cell, props, checkName(name));

    private function attachChild(props : Props, name : String) : ActorRef {
        return makeChild(_cell, props, checkName(name));
    }

    private function reserveChild(cell : ActorCell) : Void {
        _container = _container.reserve(cell.self().path().name());
    }

    private function unreserveChild(cell : ActorCell) : Void {
        _container = _container.unreserve(cell.self().path().name());
    }

    private function checkName(name : String) : String {
        return switch(name) {
            case _ if(name == null): Funk.error(ArgumentError("actor name must not be null"));
            case _ if(name == ""): Funk.error(ArgumentError("actor name must not be empty"));
            case _ if(ActorPathName.Regexp.match(name)): name;
            case _: Funk.error(ArgumentError('illegal actor name "$name"'));
        }
    }

    private function makeChild(cell : ActorCell, props : Props, name : String) : ActorRef {
        reserveChild(cell);

        var actor = try {
            var provider = cell.provider();
            var self = cell.self();
            provider.actorOf(cell.system(), props, self, self.path().child(name));
        } catch(e : Dynamic) {
            unreserveChild(cell);
            throw e;
        }

        initChild(actor);
        actor.start();
        return actor;
    }
}

interface ChildrenContainer {

    function add(name: String, stats: ActorRef): ChildrenContainer;

    function remove(child: ActorRef): ChildrenContainer;

    function getByName(name: String): Option<ChildStats>;

    function getByRef(actor: ActorRef): Option<ChildStats>;

    function children(): List<ActorRef>;

    function reserve(name: String): ChildrenContainer;

    function unreserve(name: String): ChildrenContainer;

    function isTerminating(): Bool;

    function isNormal(): Bool;
}

private enum ChildStats {
    ChildNameReserved;
    ChildRestartStats(child : ActorRef);
}

private class NormalChildrenContainer implements ChildrenContainer {

    private var _map : Map<String, ChildStats>;

    public function new(map : Map<String, ChildStats>) {
        _map = map;
    }

    public function add(name : String, child : ActorRef) : ChildrenContainer {
        _map.add(name, ChildRestartStats(child));
        return new NormalChildrenContainer(_map);
    }

    public function remove(child : ActorRef) : ChildrenContainer {
        _map.remove(child.path().name());
        return new NormalChildrenContainer(_map);
    }

    public function getByName(name : String) : Option<ChildStats> {
        return _map.get(name);
    }

    public function getByRef(actor : ActorRef) : Option<ChildStats> {
        var opt = getByName(actor.path().name());
        return switch(opt) {
            case Some(ChildNameReserved): None;
            case Some(_): opt;
            case _: None;
        }
    }

    public function children() : List<ActorRef> {
        var list = Nil;
        for(i in _map.indices()) {
            switch(getByName(i)) {
                case Some(ChildRestartStats(child)): list = list.prepend(child);
                case _:
            }
        }
        return list;
    }

    public function reserve(name : String) : ChildrenContainer {
        if(_map.exists(name)) Funk.error(ArgumentError('actor name $name is not unique!'));
        _map.add(name, ChildNameReserved);
        return new NormalChildrenContainer(_map);
    }

    public function unreserve(name : String) : ChildrenContainer {
        return if(_map.exists(name)) {
            _map.remove(name);
            new NormalChildrenContainer(_map);
        } else this;
    }

    public function isTerminating() : Bool return false;

    public function isNormal() : Bool return true;
}
