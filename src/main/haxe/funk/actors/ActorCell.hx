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

using funk.actors.dispatch.Envelope;
using funk.types.Any;
using funk.types.Option;
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

    public function sender() : ActorRef {
        return switch (_currentMessage) {
            case _ if(_currentMessage == null):
            case _ if(AnyTypes.toBool(_currentMessage.sender())): _currentMessage.sender();
            case _:
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
            case Supervise(ref):
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

    @:allow(funk.actors)
    private function system() : ActorSystem return _system;

    @:allow(funk.actors)
    private function provider() : ActorRefProvider return _system.provider();

    @:allow(funk.actors)
    private function dispatcher() : Dispatcher return _dispatcher;
}


private class Children {

    private var _cell : ActorCell;

    private var _childrenRefs : List<ActorRef>;

    public function new(cell : ActorCell) {
        _cell = cell;

        _childrenRefs = Nil;
    }

    public function actorOf(props : Props, name : String) : ActorRef return makeChild(_cell, props, checkName(name));

    private function attachChild(props : Props, name : String) : ActorRef return makeChild(_cell, props, checkName(name));

    private function checkName(name : String) : String {
        return switch(name) {
            case _ if(name == null): Funk.error(ArgumentError("actor name must not be null"));
            case _ if(name == ""): Funk.error(ArgumentError("actor name must not be empty"));
            case _ if(ActorPathName.Regexp.match(name)): name;
            case _: Funk.error(ArgumentError('illegal actor name "$name"'));
        }
    }

    private function makeChild(cell : ActorCell, props : Props, name : String) : ActorRef {
        var provider = cell.provider();
        var self = cell.self();
        var actor = provider.actorOf(cell.system(), props, self, self.path().child(name));

        initChild(actor);
        actor.start();
        return actor;
    }

    private function initChild(actor : ActorRef) : Void {
        _childrenRefs = _childrenRefs.filterNot(function(child) return child.name() == actor.name());
        _childrenRefs = _childrenRefs.prepend(actor);
    }
}
