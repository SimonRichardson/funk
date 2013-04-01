package funk.actors.routing;

import funk.Funk;
import funk.actors.Props;
import funk.actors.Actor;
import funk.actors.ActorCell;
import funk.actors.ActorRef;
import funk.actors.ActorRefProvider;
import funk.actors.dispatch.Dispatchers;
import funk.types.AnyRef;
import funk.types.Function2;
import funk.types.Pass;
import funk.types.extensions.Strings;

using funk.actors.routing.Destination;
using funk.actors.routing.RouterEnvelope;
using funk.types.Option;
using funk.collections.immutable.List;

typedef Route = Function2<ActorRef, AnyRef, List<Destination>>;

enum RouterRoutees {
    RouterRoutees(routees : List<ActorRef>);
}

class RoutedActorRef extends LocalActorRef {

    public function new(system : ActorSystem, props : Props, supervisor : InternalActorRef, path : ActorPath) {
        super(system, props, supervisor, path);
    }

    override private function newCell() : Cell {
        var actorCell = new RoutedActorCell(_system, this, _props, _supervisor);
        actorCell.init(Strings.uuid());

        return actorCell;
    }
}

class RoutedActorCell extends ActorCell {

    private var _routees : List<ActorRef>;

    public function new(system : ActorSystem, self : InternalActorRef, props : Props, parent : InternalActorRef) {
        super(system, self, props
                            .withCreator(new RoutedActorCellCreator())
                            .withDispatcher(Dispatchers.DefaultDispatcherId),
                            parent);
        _routees = Nil;
    }

    public function addRoutees(routees : List<ActorRef>) : Void {
        _routees = _routees.prependAll(routees);
        routees.foreach(function(routee) watch(routee));
    }

    public function removeRoutees(routees : List<ActorRef>) : Void {
        _routees = routees.foldLeft(_routees, function(xs, x) {
            unwatch(x);
            return xs.filterNot(function(v) return v == x);
        }).get();
    }

    public function routees() : List<ActorRef> return _routees;
}

class RoutedActorCellCreator implements Creator {

    public function new() {
    }

    public function create() : Actor return Pass.instanceOf(Router)();
}

class Router extends Actor {

    private var _ref : RoutedActorCell;

    public function new() {
        super();

        var c = context();
        _ref = switch(c) {
            case _ if(Std.is(c, RoutedActorCell)): cast c;
            case _: Funk.error(ActorError('Router actor can only be used in RoutedActorRef, not in ${c}'));
        }
    }

    override public function receive(value : AnyRef) : Void {
        switch(value) {
            case _ if(Std.is(value, ActorMessages)):
                var actorMsg : ActorMessages = cast value;
                switch(actorMsg) {
                    case Terminated(child):
                        _ref.removeRoutees(Nil.prepend(child));
                        if(_ref.routees().isEmpty()) context().stop();
                }
        }
    }

    override public function preRestart(reason : Errors, message : Option<AnyRef>) : Void {}
}

interface RouterConfig {

    function createRoute(routeeProvider : RouteeProvider) : Route;

    function createActor() : Actor;

    function createRouteeProvider(context : ActorContext, routeeProps : Props) : RouteeProvider;
}

class NoRouter implements RouterConfig {

    public function new() {}

    public function createRoute(routeeProvider : RouteeProvider) : Route {
        return Funk.error(ActorError("NoRouter does not createRoute"));
    }

    public function createActor() : Actor return Funk.error(ActorError("NoRouter does not createActor"));

    public function createRouteeProvider(context : ActorContext, routeeProps : Props) : RouteeProvider {
        return Funk.error(ActorError("NoRouter does not createRouteeProvider"));
    }
}
