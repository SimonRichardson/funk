package funk.actors;

import funk.actors.Actor;
import funk.actors.ActorContext;
import funk.actors.ActorSystem;
import funk.actors.ActorPath;
import funk.actors.ActorRef;
import funk.actors.dispatch.SystemMessage;
import funk.types.extensions.EnumValues;

using funk.types.Any;
using funk.types.Option;
using funk.ds.immutable.Map;
using funk.ds.immutable.List;

enum SuspendReason {
    Normal;
    Termination;
    Creation;
    UserRequest;
    Recreation(cause : Dynamic);
}

enum ChildStats {
    ChildNameReserved;
    ChildRestartStats(child : ActorRef, uid : String);
}

class ChildStatsTypes {

    public static function child(stats : ChildStats) : ActorRef {
        return switch (stats) {
            case ChildRestartStats(c, _): c;
            case _: null;
        }
    }

    public static function uid(stats : ChildStats) : String {
        return switch (stats) {
            case ChildRestartStats(_, uid): uid;
            case _: null;
        }
    }
}

class Children {

    private var _cell : ActorCell;

    private var _container : ChildrenContainer;

    public function new(cell : ActorCell) {
        _cell = cell;

        _container = new NormalChildrenContainer(MapType.Nil);
    }

    public function initChild(ref : ActorRef) : Option<ChildStats> {
        var name = ref.path().name();
        var opt = _container.getByName(name);
        return switch(opt) {
            case Some(ChildRestartStats(_, _)): opt;
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
                    case Some(ChildRestartStats(a, _)):
                        _container = _container.remove(a);
                        Some(ref);
                    case _: None;
                }
        }
    }

    public function setChildrenTerminationReason(reason : SuspendReason) : Bool {
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

    public function removeChildAndGetStateChange(child : ActorRef) : Option<SuspendReason> {
        return switch(_container) {
            case _ if(AnyTypes.isInstanceOf(_container, TerminatingChildrenContainer)):
                var c : TerminatingChildrenContainer = AnyTypes.asInstanceOf(_container, TerminatingChildrenContainer);
                switch(removeChild(child)) {
                    case None: None;
                    case _: Some(c.reason());
                }
            case _:
                removeChild(child);
                None;
        }
    }

    // TODO (Simon) : Implement waiting for children for Terminating containers.
    inline public function waitingForChildren() : Option<WaitingForChildren> return None;

    inline public function actorOf(props : Props, name : String) : ActorRef return makeChild(_cell, props, checkName(name));

    inline public function children() : List<ActorRef> return _container.children();

    inline public function getAllChildStats() : List<ChildStats> return _container.stats();

    inline public function child(name : String) : Option<ActorRef> return getChild(name).toOption();

    inline public function getChildByName(name : String) : Option<ChildStats> return _container.getByName(name);

    inline public function getChildByRef(actor : ActorRef) : Option<ChildStats> return _container.getByRef(actor);

    public function getChild(name : String) : ActorRef {
        return switch(_container.getByName(name)) {
            case Some(ChildRestartStats(a, _)): a;
            case _: null;
        }
    }

    inline public function container() : ChildrenContainer return _container;

    inline public function isTerminating() : Bool return _container.isTerminating();

    inline public function isNormal() : Bool return _container.isNormal();

    @:allow(funk.actors)
    private function attachChild(props : Props, name : String) : ActorRef {
        return makeChild(_cell, props, checkName(name));
    }

    @:allow(funk.actors)
    private function reserveChild(name : String) : Void _container = _container.reserve(name);

    @:allow(funk.actors)
    private function unreserveChild(name : String) : Void _container = _container.unreserve(name);

    @:allow(funk.actors)
    private function suspendChildren(exceptFor : List<ActorRef>) : Void {
        _container.children().foreach(function(child) {
            if (!exceptFor.contains(child)) AnyTypes.asInstanceOf(child, InternalActorRef).suspend();
        });
    }

    @:allow(funk.actors)
    private function resumeChildren(causedByFailure : Dynamic, perp : ActorRef) : Void {
        _container.children().foreach(function(child) {
            AnyTypes.asInstanceOf(child, InternalActorRef).resume((perp == child) ? causedByFailure : null);
        });
    }

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

class WaitingForChildren {

    private var _todo : List<SystemMessage>;

    public function new(){
        _todo = Nil;
    }

    public function enqueue(message : SystemMessage) : Void _todo.prepend(message);

    public function dequeueAll() : List<SystemMessage> {
        var result = _todo;
        _todo = null;
        return result;
    }
}

interface ChildrenContainer {

    function add(name : String, stats : ActorRef) : ChildrenContainer;

    function remove(child : ActorRef) : ChildrenContainer;

    function getByName(name : String) : Option<ChildStats>;

    function getByRef(actor : ActorRef) : Option<ChildStats>;

    function children() : List<ActorRef>;

    function stats() : List<ChildStats>;

    function reserve(name : String) : ChildrenContainer;

    function unreserve(name : String) : ChildrenContainer;

    function isTerminating() : Bool;

    function isNormal() : Bool;
}

class NormalChildrenContainer implements ChildrenContainer {

    private var _map : Map<String, ChildStats>;

    public function new(map : Map<String, ChildStats>) {
        _map = map;
    }

    public function add(name : String, child : ActorRef) : ChildrenContainer {
        var map = _map.add(name, ChildRestartStats(child, child.uid()));
        return new NormalChildrenContainer(map);
    }

    public function remove(child : ActorRef) : ChildrenContainer {
        var map = _map.remove(child.path().name());
        return new NormalChildrenContainer(map);
    }

    inline public function getByName(name : String) : Option<ChildStats> return _map.get(name);

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
                case Some(ChildRestartStats(child, _)): list = list.prepend(child);
                case _:
            }
        }
        return list;
    }

    public function stats() : List<ChildStats> {
        var list = Nil;
        for(i in _map.values()) {
            switch(i) {
                case ChildRestartStats(_): list = list.prepend(i);
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

    inline public function toTermination() : TerminatingChildrenContainer {
        return new TerminatingChildrenContainer(_map, UserRequest);
    }

    inline public function isTerminating() : Bool return false;

    inline public function isNormal() : Bool return true;
}

class TerminatingChildrenContainer implements ChildrenContainer {

    private var _map : Map<String, ChildStats>;

    private var _reason : SuspendReason;

    public function new(map : Map<String, ChildStats>, reason : SuspendReason) {
        _map = map;
        _reason = reason;
    }

    public function add(name : String, child : ActorRef) : ChildrenContainer {
        var map = _map.add(name, ChildRestartStats(child, child.uid()));
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

    inline public function getByName(name : String) : Option<ChildStats> return _map.get(name);

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
                case Some(ChildRestartStats(child, _)): list = list.prepend(child);
                case _:
            }
        }
        return list;
    }

    public function stats() : List<ChildStats> {
        var list = Nil;
        for(i in _map.values()) {
            switch(i) {
                case ChildRestartStats(_): list = list.prepend(i);
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

    inline public function reason() : SuspendReason return _reason;

    inline public function isTerminating() : Bool return EnumValues.equals(_reason, Termination);

    inline public function isNormal() : Bool return EnumValues.equals(_reason, UserRequest);
}

class TerminatedChildrenContainer implements ChildrenContainer {

    public function new() {}

    public function add(name : String, child : ActorRef) : ChildrenContainer {
        return Funk.error(ActorError('cannot reserve actor name ${name} already terminated'));
    }

    public function remove(child : ActorRef) : ChildrenContainer {
        return Funk.error(ActorError('cannot reserve actor name ${child.path().name()} already terminated'));
    }

    inline public function getByName(name : String) : Option<ChildStats> return None;

    inline public function getByRef(actor : ActorRef) : Option<ChildStats> return None;

    inline public function children() : List<ActorRef> return Nil;

    inline public function stats() : List<ChildStats> return Nil;

    public function reserve(name : String) : ChildrenContainer {
        return Funk.error(ActorError('cannot reserve actor name ${name} already terminated'));
    }

    public function unreserve(name : String) : ChildrenContainer {
        return Funk.error(ActorError('cannot reserve actor name ${name} already terminated'));
    }

    inline public function isTerminating() : Bool return true;

    inline public function isNormal() : Bool return false;
}
