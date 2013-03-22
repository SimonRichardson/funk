package funk.actors;

import funk.Funk;
import funk.actors.dispatch.Envelope;
import funk.actors.dispatch.Mailbox;
import funk.actors.dispatch.MessageDispatcher;
import funk.actors.Actor;
import funk.actors.ActorSystem;
import funk.actors.ActorPath;
import funk.actors.ActorRef;
import funk.actors.ActorRefProvider;

using funk.types.Any;
using funk.types.Option;
using funk.collections.immutable.List;

class ActorCell implements ActorContext {

    private var _self : ActorRef;

    private var _system : ActorSystem;

    private var _props : Props;

    private var _parent : ActorRef;

    private var _children : Children;

    public function new(system : ActorSystem, self : ActorRef, props : Props, parent : ActorRef) {
        _system = system;
        _self = self;
        _props = props;
        _parent = parent;

        _children = new Children(this);
    }

    public function start() : ActorContext {
        return this;
    }

    public function actorOf(props : Props, name : String) : ActorRef return _children.actorOf(props, name);

    public function self() : ActorRef return _self;

    public function sender() : ActorRef {
        return null;
    }

    @:allow(funk.actors)
    private function system() : ActorSystem return _system;

    @:allow(funk.actors)
    private function provider() : ActorRefProvider return _system.provider();
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
