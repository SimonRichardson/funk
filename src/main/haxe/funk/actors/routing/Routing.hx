package funk.actors.routing;

import funk.Funk;
import funk.actors.Props;
import funk.actors.ActorCell;
import funk.actors.ActorRef;
import funk.actors.ActorRefProvider;
import funk.actors.dispatch.Dispatchers;
import funk.types.AnyRef;
import funk.types.Pass;

using funk.types.Option;

class RoutedActorRef extends LocalActorRef {

    public function new(system : ActorSystem, props : Props, supervisor : InternalActorRef, path : ActorPath) {
        super(system, props, supervisor, path);
    }

    override private function newCell() : Cell {
        var actorCell = new RoutedActorCell(_system, this, _props, _supervisor);
        actorCell.init(ActorSystem.UniqueId);

        return actorCell;
    }
}

class RoutedActorCell extends ActorCell {

    public function new(system : ActorSystem, self : InternalActorRef, props : Props, parent : InternalActorRef) {
        super(system, self, props
                            .withCreator(new RoutedActorCellCreator())
                            .withDispatcher(Dispatchers.DefaultDispatcherId),
                            parent);
    }
}

class RoutedActorCellCreator implements Creator {

    public function new() {
    }

    public function create() : Actor return null;//Pass.instanceOf(RoutedActorCell)();
}

class Router {

    public function new() {
        //super();
    }

    /*
    override public function receive(value : AnyRef) : Void {

    }

    override public function preRestart(reason : Errors, message : Option<AnyRef>) : Void {}
    */
}

class NoRouter extends Router {

    public function new() {
        super();
    }
}
