package funk.actors;

import funk.Funk;
import funk.actors.dispatch.Envelope;
import funk.actors.dispatch.Mailbox;
import funk.actors.dispatch.MessageDispatcher;
import funk.actors.Actor;
import funk.actors.ActorSystem;
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

    public function new(system : ActorSystem, self : ActorRef, props : Props, parent : ActorRef) {
        _system = system;
        _self = self;
        _props = props;
        _parent = parent;
    }

    public function start() : ActorContext {
        return this;
    }

    public function actorOf(props : Props, name : String) : ActorRef {
        return null;
    }

    public function self() : ActorRef return _self;

    public function sender() : ActorRef {
        return null;
    }
}
