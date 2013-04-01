package funk.actors.routing;

import funk.actors.routing.Destination;
import funk.actors.routing.RouteeProvider;
import funk.actors.routing.Routing;
import funk.types.AnyRef;

using funk.types.Option;
using funk.collections.immutable.List;

class RoundRobinRouter implements RouterConfig {

    private var _nrOfInstances : Int;

    private var _routees : List<String>;

    public function new(nrOfInstances : Int) {
        _nrOfInstances = nrOfInstances;

        _routees = Nil;
    }

    public function createRoute(routeeProvider : RouteeProvider) : Route {
        if (_routees.isEmpty()) routeeProvider.createRoutees(_nrOfInstances);
        else routeeProvider.registerRouteesFor(_routees);

        var next = 0;

        function getNext() : ActorRef {
            var currentRoutees : List<ActorRef> = routeeProvider.routees();
            return if (currentRoutees.isEmpty()) {
                var context = routeeProvider.context();
                context.system().deadLetters();
            } else {
                // Just get it.
                currentRoutees.get((next++) % currentRoutees.size()).get();
            }
        }

        function createDestinations(sender : ActorRef) : List<Destination> {
            return Nil.prepend(Destination(sender, getNext()));
        }

        return function(sender : ActorRef, message : AnyRef) : List<Destination> {
            return switch(message) {
              case _ if(Std.is(message, RouterEnvelope)):
                var envelope : RouterEnvelope = cast message;
                switch(envelope) {
                    case Broadcast(_): toAll(sender, routeeProvider.routees());
                    case _: createDestinations(sender);
                }
              case _: createDestinations(sender);
            }
        };
    }

    public function createActor() : Actor return new Router();

    public function createRouteeProvider(context : ActorContext, routeeProps : Props) : RouteeProvider {
        return new RouteeProvider(context, routeeProps);
    }

    public function nrOfInstances() : Int return _nrOfInstances;

    private function toAll(sender : ActorRef, routees : List<ActorRef>) : List<Destination> {
        return routees.map(function(value) return Destination(sender, value));
    }
}
