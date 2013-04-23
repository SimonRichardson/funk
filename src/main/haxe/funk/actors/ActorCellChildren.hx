package funk.actors;

import funk.actors.Actor;
import funk.actors.ActorContext;
import funk.actors.ActorSystem;
import funk.actors.ActorPath;
import funk.actors.ActorRef;
import funk.types.extensions.EnumValues;

using funk.types.Any;
using funk.types.Option;
using funk.collections.immutable.Map;
using funk.collections.immutable.List;

enum Containers {
    Normal;
    Termination;
}

class Children {

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
