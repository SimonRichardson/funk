package funk.actors;

import funk.actors.dispatch.Dispatcher;
import funk.actors.dispatch.SystemMessage;
import funk.Funk;
import funk.actors.dispatch.Mailbox;
import funk.actors.Actor;
import funk.actors.ActorContext;
import funk.actors.ActorSystem;
import funk.actors.ActorPath;
import funk.actors.ActorRef;
import funk.actors.ActorRefProvider;
import funk.actors.events.LoggingBus;
import funk.types.Any.AnyTypes;
import funk.types.AnyRef;
import funk.types.Predicate1;
import funk.types.extensions.EnumValues;
import funk.io.logging.LogLevel;
import funk.io.logging.LogValue;
import haxe.ds.StringMap;
import haxe.Serializer;
import haxe.Unserializer;

using funk.actors.dispatch.EnvelopeMessage;
using funk.types.Any;
using funk.types.Option;
using funk.collections.immutable.Map;
using funk.collections.immutable.List;

interface Cell extends ActorContext {

    function init(uid : String, ?sendSupervise : Bool = true) : Void;

    function start() : ActorContext;

    function stop() : ActorContext;

    function sendMessage(msg : EnvelopeMessage) : Void;

    function sendSystemMessage(msg : SystemMessage) : Void;

    function parent() : InternalActorRef;

    function child(name : String) : Option<ActorRef>;

    function getChildByName(name : String) : Option<ChildStats>;

    function become(value : Predicate1<AnyRef>, ?discardLast : Bool = false) : Void;

    function unbecome() : Void;
}

class ActorCell implements Cell implements ActorContext {

    private var _uid : String;

    private var _actor : Actor;

    private var _self : InternalActorRef;

    private var _system : ActorSystem;

    private var _props : Props;

    private var _parent : InternalActorRef;

    private var _children : Children;

    private var _dispatcher : Dispatcher;

    private var _currentMessage : EnvelopeMessage;

    private var _mailbox : Mailbox;

    private var _watching : List<ActorRef>;

    private var _becomingStack : List<Predicate1<AnyRef>>;

    public function new(system : ActorSystem, self : InternalActorRef, props : Props, parent : InternalActorRef) {
        _system = system;
        _self = self;
        _props = props;
        _parent = parent;

        _watching = Nil;
        _becomingStack = Nil.prepend(actorRecieve());

        _children = new Children(this);

        var dispatchers = _system.dispatchers();
        _dispatcher = dispatchers.find(_props.dispatcher());

        _mailbox = _dispatcher.createMailbox(this);
    }

    public function init(uid : String, ?sendSupervise : Bool = true) : Void {
        _mailbox.systemEnqueue(_self, Create(uid));

        if (sendSupervise) {
            _parent.sendSystemMessage(Supervise(_self, false, uid));
            // TODO (Simon) : Because we don't have async executions we can't send this.
            //_parent.send(NullMessage);
        }
    }

    public function start() : ActorContext {
        try _dispatcher.attach(this) catch (e : Dynamic) handleException(e);
        return this;
    }

    public function stop() : ActorContext {
        try _dispatcher.systemDispatch(this, Terminate) catch (e : Dynamic) handleException(e);
        return this;
    }

    public function actorOf(props : Props, name : String) : ActorRef return _children.actorOf(props, name);

    public function actorFor(path : ActorPath) : Option<ActorRef> return _system.provider().actorFor(path);

    public function self() : InternalActorRef return _self;

    public function mailbox() : Mailbox return _mailbox;

    public function children() : List<ActorRef> return _children.children();

    public function system() : ActorSystem return _system;

    public function parent() : InternalActorRef return _parent;

    public function child(name : String) : Option<ActorRef> return _children.child(name);

    public function getChildByName(name : String) : Option<ChildStats> return _children.getChildByName(name);

    public function isTerminating() : Bool return _children.isTerminating();

    public function isTerminated() : Bool return _mailbox.isClosed();

    public function hasMessages() : Bool return _mailbox.hasMessages();

    public function numberOfMessages() : Int return _mailbox.numberOfMessages();

    public function sender() : Option<ActorRef> {
        return switch (_currentMessage) {
            case _ if(_currentMessage == null): Some(_system.deadLetters());
            case _ if(AnyTypes.toBool(_currentMessage.sender())): Some(_currentMessage.sender());
            case _: Some(_system.deadLetters());
        }
    }

    public function watch(actor : ActorRef) : Void {
        var a = AnyTypes.asInstanceOf(actor, InternalActorRef);
        if(a != self() && !_watching.exists(function(child) return child == a)) {
            a.sendSystemMessage(Watch(a, self()));
            _watching = _watching.prepend(a);
        }
    }

    public function unwatch(actor : ActorRef) : Void {
        var a = AnyTypes.asInstanceOf(actor, InternalActorRef);
        if(a != self() && _watching.exists(function(child) return child == a)) {
            a.sendSystemMessage(Unwatch(a, self()));
            _watching = _watching.filterNot(function(child) return child == a);
        }
    }

    public function sendMessage(envelope : EnvelopeMessage) : Void {
        try {
            // Note (Simon) : This be expensive, but good for thread safety (Share nothing)
            var msg = envelope.message();
            var message = if (_system.settings().serializeAllMessages()) Unserializer.run(Serializer.run(msg)) else msg;

            var sender = envelope.sender();
            var ref = AnyTypes.toBool(sender) ? sender : null;

            _dispatcher.dispatch(this, Envelope(message, ref));
        } catch(e : Dynamic) {
            handleException(e);
            throw e;
        }
    }

    public function sendSystemMessage(message : SystemMessage) : Void {
        try _dispatcher.systemDispatch(this, message) catch(e : Dynamic) {
            handleException(e);
            throw e;
        }
    }

    public function systemInvoke(message : SystemMessage) : Void {
        switch(message) {
            case Create(uid): systemCreate(uid);
            case Supervise(cell, async, uid): systemSupervise(cell, async, uid);
            case ChildTerminated(child): handleChildTerminated(child);
            case Terminate: systemTerminate();
            case Watch(watchee, watcher): addWatcher(watchee, watcher);
            case Unwatch(watchee, watcher): remWatcher(watchee, watcher);
            case _:
        }
    }

    public function invoke(message : EnvelopeMessage) : Void {
        _currentMessage = message;
        var msg : AnyRef = message.message();
        switch(msg) {
            case _ if(AnyTypes.isEnum(msg) && EnumValues.getEnum(msg) == ActorMessages):
                autoReceiveMessage(message);
            case _: receiveMessage(msg);
        }
        _currentMessage = null;
    }

    public function become(value : Predicate1<AnyRef>, ?discardLast : Bool = false) : Void {
        // Note: discard last can actually be very dangerous, by removing the last actor receive.
        if(discardLast) _becomingStack = _becomingStack.tail();
        _becomingStack = _becomingStack.prepend(value);
    }

    public function unbecome() : Void {
        _becomingStack = _becomingStack.tail();

        // Make sure we add the actor receiver back onto the stack
        if (_becomingStack.isEmpty()) {
            _becomingStack = _becomingStack.prepend(actorRecieve());
        }
    }

    public function initChild(ref : ActorRef) : Option<ChildStats> return _children.initChild(ref);

    public function attachChild(props : Props, name : String) : ActorRef return _children.attachChild(props, name);

    private function actorRecieve() : Predicate1<AnyRef> {
        return function(value : AnyRef) : Bool {
            _actor.receive(value);
            return false;
        };
    }

    private function autoReceiveMessage(message : EnvelopeMessage) : Void {
        // TODO (Simon) : Work on auto received messages.
    }

    private function receiveMessage(message : AnyRef) : Void {
        var p = _becomingStack;
        while(p.nonEmpty()) {
            var func = p.head();
            if (!func(message)) {
                break;
            }
            p = p.tail();
        }
    }

    private function newActor() : Actor {
        ActorContextInjector.pushContext(this);

        function finally() {
            ActorContextInjector.popContext();
        }

        var instance = null;
        try {
            var creator = _props.creator();
            instance = creator();
            if (!AnyTypes.toBool(instance)) {
                Funk.error(ActorError("Actor instance passed to actorOf can't be 'null'"));
            }
        } catch(e : Dynamic) {
            finally();
            publish(Error, ErrorMessage(e, self().path().toString(), null, 'unable to create new actor'));
            throw e;
        }

        finally();

        return instance;
    }

    private function systemCreate(uid : String) : Void {
        this._uid = uid;

        try {
            _actor = newActor();
            _actor.preStart();
        } catch (e : Dynamic) {
            if (AnyTypes.toBool(_actor)) {
                clearActorFields(_actor);
                _actor = null;
                _currentMessage = null;
            }
            publish(Error, ErrorMessage(e, self().path().toString(), null, 'unable to create system ${uid}'));
            throw e;
        }
    }

    private function systemSupervise(child : ActorRef, async : Bool, uid : String) : Void {
        if (!isTerminating()) {
            switch(_children.initChild(child)) {
                case Some(crs):
                    // Work out what to do here, is the uid required?
                    // crs.uid = uid;
                    handleSystemSupervise(crs, async);
                case _:
                    var msg = 'received Supervise from unregistered child "${child.path()}", this will not end well';
                    publish(Warn, WarnMessage(self().path().toString(), Type.getClass(_actor), msg));
                    Funk.error(ActorError(msg));
            }
        } else publish(Debug, DebugMessage( self().path().toString(),
                                            Type.getClass(_actor),
                                            'unable to supervise when terminating'
                                            ));
    }

    private function handleSystemSupervise(child : ChildStats, async : Bool) : Void {
        // TODO (Simon) : Implement RepointableActorRef.
    }

    private function systemTerminate() : Void {
        unwatchWatchedActors(_actor);

        children().foreach(function(child) AnyTypes.asInstanceOf(child, InternalActorRef).stop());

        if(!setChildrenTerminationReason(Termination)) finishTerminate();
    }

    private function setChildrenTerminationReason(reason : Containers) : Bool {
        return _children.setChildrenTerminationReason(reason);
    }

    private function finishTerminate() : Void {
        var a = _actor;

        if(AnyTypes.toBool(a)) a.postStop();

        _dispatcher.detach(this);
        _parent.sendSystemMessage(ChildTerminated(_self));

        if(AnyTypes.toBool(a)) {
            unwatchWatchedActors(a);
            clearActorFields(a);

            _actor = null;
        }
    }

    private function clearActorFields(actor : Actor) : Void {
        _actor._context = null;
        _actor._self = null;
    }

    private function handleChildTerminated(child : ActorRef) : Void {
        _children.removeChild(child);
    }

    private function unwatchWatchedActors(actor : Actor) : Void {
        if(!_watching.isEmpty()) {
            _watching.foreach(function(a) {
                if(AnyTypes.isInstanceOf(a, InternalActorRef)) {
                    var watchee : InternalActorRef = cast a;
                    watchee.sendSystemMessage(Unwatch(watchee, self()));
                }
            });

            _watching = Nil;
        }
    }

    private function addWatcher(watchee : ActorRef, watcher : ActorRef) : Void {

    }

    private function remWatcher(watchee : ActorRef, watcher : ActorRef) : Void {

    }

    private function handleException(e : Dynamic) : Void {
        // TODO (Simon) : Handle other errors.
        switch(e){
            case _: publish(Error, ErrorMessage(    e, 
                                                    self().path().toString(), 
                                                    Type.getClass(_actor),
                                                    "exception during system message send"
                                                    ));
        }
    }

    private function publish(level : LogLevel, event : LogMessages) : Void {
        system().eventStream().publish(Data(level, event));
    }

    @:allow(funk.actors)
    private function actor() : Actor return _actor;

    @:allow(funk.actors)
    private function provider() : ActorRefProvider return _system.provider();

    @:allow(funk.actors)
    private function dispatcher() : Dispatcher return _dispatcher;

    @:allow(funk.actors)
    private function reserveChild(name : String) : Void _children.reserveChild(name);

    @:allow(funk.actors)
    private function unreserveChild(name : String) : Void _children.unreserveChild(name);

    @:allow(funk.actors)
    private function currentMessage() : EnvelopeMessage return _currentMessage;

    @:allow(funk.actors)
    private function childrenRefs() : ChildrenContainer return _children.container();

    public function toString() return '[ActorCell (path=${self().path()})]';
}

private enum Containers {
    Normal;
    Termination;
}

private class Children {

    private var _cell : ActorCell;

    private var _container : ChildrenContainer;

    public function new(cell : ActorCell) {
        _cell = cell;

        _container = new NormalChildrenContainer(Empty);
    }

    public function initChild(ref : ActorRef) : Option<ChildStats> {
        var name = ref.path().name();
        var opt = _container.getByName(name);
        return switch(opt) {
            case Some(ChildRestartStats(_)): opt;
            case Some(ChildNameReserved):
                _container = _container.add(name, ref);
                _container.getByName(name);
            case _: None;
        }
    }

    public function removeChild(ref : ActorRef) : Option<ActorRef> {
        return switch(_container) {
            case _ if(AnyTypes.isInstanceOf(_container, TerminatedChildrenContainer)): None;
            case _:
                switch(_container.getByRef(ref)) {
                    case Some(ChildRestartStats(a)):
                        _container = _container.remove(a);
                        Some(ref);
                    case _: None;
                }
        }
    }

    public function setChildrenTerminationReason(reason : Containers) : Bool {
        // Return true on change
        return switch(reason) {
            case Termination if(AnyTypes.isInstanceOf(_container, NormalChildrenContainer)):
                var c : NormalChildrenContainer = cast _container;
                _container = c.toTermination();
                true;
            case Termination if(_container.isTerminating()): false;
            case _: false;
        }
    }

    public function actorOf(props : Props, name : String) : ActorRef return makeChild(_cell, props, checkName(name));

    public function children() : List<ActorRef> return _container.children();

    public function child(name : String) : Option<ActorRef> return getChild(name).toOption();

    public function getChildByName(name : String) : Option<ChildStats> return _container.getByName(name);

    public function getChild(name : String) : ActorRef {
        return switch(_container.getByName(name)) {
            case Some(ChildRestartStats(a)): a;
            case _: null;
        }
    }

    public function container() : ChildrenContainer return _container;

    public function isTerminating() : Bool return _container.isTerminating();

    @:allow(funk.actors)
    private function attachChild(props : Props, name : String) : ActorRef {
        return makeChild(_cell, props, checkName(name));
    }

    @:allow(funk.actors)
    private function reserveChild(name : String) : Void _container = _container.reserve(name);

    @:allow(funk.actors)
    private function unreserveChild(name : String) : Void _container = _container.unreserve(name);

    private function checkName(name : String) : String {
        return switch(name) {
            case _ if(name == null): Funk.error(ArgumentError("actor name must not be null"));
            case _ if(name == ""): Funk.error(ArgumentError("actor name must not be empty"));
            case _ if(ActorPathName.NameRegexp.match(name)): name;
            case _: Funk.error(ArgumentError('illegal actor name "$name"'));
        }
    }

    private function makeChild(cell : ActorCell, props : Props, name : String) : ActorRef {
        reserveChild(name);

        var actor = try {
            var provider = cell.provider();
            var self = cell.self();
            provider.actorOf(cell.system(), props, self, self.path().child(name));
        } catch(e : Dynamic) {
            unreserveChild(name);
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

enum ChildStats {
    ChildNameReserved;
    ChildRestartStats(child : ActorRef);
}

class NormalChildrenContainer implements ChildrenContainer {

    private var _map : Map<String, ChildStats>;

    public function new(map : Map<String, ChildStats>) {
        _map = map;
    }

    public function add(name : String, child : ActorRef) : ChildrenContainer {
        var map = _map.add(name, ChildRestartStats(child));
        return new NormalChildrenContainer(map);
    }

    public function remove(child : ActorRef) : ChildrenContainer {
        var map = _map.remove(child.path().name());
        return new NormalChildrenContainer(map);
    }

    public function getByName(name : String) : Option<ChildStats> return _map.get(name);

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
        var map = _map.add(name, ChildNameReserved);
        return new NormalChildrenContainer(map);
    }

    public function unreserve(name : String) : ChildrenContainer {
        return if(_map.exists(name)) {
            var map = _map.remove(name);
            new NormalChildrenContainer(map);
        } else this;
    }

    public function toTermination() : TerminatingChildrenContainer {
        return new TerminatingChildrenContainer(_map, UserRequest);
    }

    public function isTerminating() : Bool return false;

    public function isNormal() : Bool return true;
}

enum TerminationReason {
    UserRequest;
    Termination;
}

class TerminatingChildrenContainer implements ChildrenContainer {

    private var _map : Map<String, ChildStats>;

    private var _reason : TerminationReason;

    public function new(map : Map<String, ChildStats>, reason : TerminationReason) {
        _map = map;
        _reason = reason;
    }

    public function add(name : String, child : ActorRef) : ChildrenContainer {
        var map = _map.add(name, ChildRestartStats(child));
        return new TerminatingChildrenContainer(map, _reason);
    }

    public function remove(child : ActorRef) : ChildrenContainer {
        var map = _map.remove(child.path().name());

        return if (map.isEmpty()) {
            switch(_reason) {
                case Termination: new TerminatedChildrenContainer();
                case _: new NormalChildrenContainer(map);
            }
        } else new TerminatingChildrenContainer(map, UserRequest);
    }

    public function getByName(name : String) : Option<ChildStats> return _map.get(name);

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
        return Funk.error(ActorError('cannot reserve actor name ${name} already terminating'));
    }

    public function unreserve(name : String) : ChildrenContainer {
        return if(_map.exists(name)) {
            var map = _map.remove(name);
            new TerminatingChildrenContainer(map, _reason);
        } else this;
    }

    public function isTerminating() : Bool return EnumValues.equals(_reason, Termination);

    public function isNormal() : Bool return EnumValues.equals(_reason, UserRequest);
}

class TerminatedChildrenContainer implements ChildrenContainer {

    public function new() {}

    public function add(name : String, child : ActorRef) : ChildrenContainer {
        return Funk.error(ActorError('cannot reserve actor name ${name} already terminated'));
    }

    public function remove(child : ActorRef) : ChildrenContainer {
        return Funk.error(ActorError('cannot reserve actor name ${child.path().name()} already terminated'));
    }

    public function getByName(name : String) : Option<ChildStats> return None;

    public function getByRef(actor : ActorRef) : Option<ChildStats> return None;

    public function children() : List<ActorRef> return Nil;

    public function reserve(name : String) : ChildrenContainer {
        return Funk.error(ActorError('cannot reserve actor name ${name} already terminated'));
    }

    public function unreserve(name : String) : ChildrenContainer {
        return Funk.error(ActorError('cannot reserve actor name ${name} already terminated'));
    }

    public function isTerminating() : Bool return true;

    public function isNormal() : Bool return false;
}
