package funk.actors.routing;

import funk.Funk;
import funk.actors.ActorContext;
import funk.actors.Props;
import funk.actors.routing.Routing;
import funk.collections.immutable.ListUtil;

using funk.types.Option;
using funk.collections.immutable.List;

class RouteeProvider {

    private var _context : ActorContext;

    private var _routeeProps : Props;

    public function new(context : ActorContext, routeeProps : Props) {
        _context = context;
        _routeeProps = routeeProps;
    }

    public function registerRoutees(routees : List<ActorRef>) : Void routedCell().addRoutees(routees);

    public function unregisterRoutees(routees : List<ActorRef>) : Void routedCell().removeRoutees(routees);

    public function registerRouteesFor(paths : List<String>) : Void {
        registerRoutees(paths.map(function(value) return context().actorFor(value).get()));
    }

    public function createRoutees(nrOfInstances : Int) : Void {
        if (nrOfInstances <= 0) {
            Funk.error(ArgumentError('Must specify nrOfInstances or routees for ${_context.self().path()}'));
        } else registerRoutees(ListUtil.fill(nrOfInstances)(function() return _context.actorOf(_routeeProps, '')));
    }

    public function removeRoutees(nrOfInstances : Int) : Void {
        if (nrOfInstances <= 0) {
            Funk.error(ArgumentError('Must specify nrOfInstances or routees for ${_context.self().path()}'));
        } else {
            var currentRoutees = routees();
            var abandon = currentRoutees.dropLeft(currentRoutees.size() - nrOfInstances);
            unregisterRoutees(abandon);

            // TODO (Simon) : PoisonPill
            // if (abandon.nonEmpty) abandon.foreach(function(ref) ref.send(PoisonPill, ref));
        }
    }

    public function context() : ActorContext return _context;

    public function routeeProps() : Props return _routeeProps;

    @:allow(funk.actors.routing)
    private function routees() : List<ActorRef> return routedCell().routees();

    private function routedCell() : RoutedActorCell return cast _context;
}
