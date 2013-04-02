package funk.actors.routing;

import funk.actors.dispatch.Envelope;
import funk.actors.routing.Destination;
import funk.Funk;
import funk.actors.Props;
import funk.actors.Actor;
import funk.actors.ActorCell;
import funk.actors.ActorRef;
import funk.actors.ActorRefProvider;
import funk.actors.dispatch.Dispatchers;
import funk.types.Any.AnyTypes;
import funk.types.AnyRef;
import funk.types.Function2;
import funk.types.Pass;
import funk.types.extensions.Strings;

using funk.actors.dispatch.Envelope;
using funk.actors.routing.Destination;
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

    override private function newCell() : Cell return new RoutedActorCell(_system, this, _props, _supervisor);

    override private function initCell() : Void _actorCell.init(Strings.uuid(), false);
}

class RoutedActorCell extends ActorCell {

    private var _routees : List<ActorRef>;

    private var _route : Route;

    private var _routedProps : Props;

    private var _routeeProvider : RouteeProvider;

    public function new(system : ActorSystem, self : InternalActorRef, props : Props, parent : InternalActorRef) {
        super(system, self, props
                            .withCreator(new RoutedActorCellCreator())
                            .withDispatcher(Dispatchers.DefaultDispatcherId),
                            parent);
        _routedProps = props;

        _routees = Nil;
    }

    override public function init(uid : String, ?sendSupervise : Bool = true) : Void {
        super.init(uid, sendSupervise);

        var routerConfig = _props.router();

        _routeeProvider = routerConfig.createRouteeProvider(this, _routedProps.withRouter(new NoRouter()));
        _route = routerConfig.createRoute(_routeeProvider);
    }

    public function applyRoute(sender : ActorRef, message : AnyRef) : List<Destination> {
        return switch(message) {
            case _ if (AnyTypes.toBool(sender) && AnyTypes.toBool(message)): _route(sender, message);
            case _: Nil;
        }
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

    override public function sendMessage(msg : Envelope) : Void {
        var message : Envelope = switch (msg) {
            case RouterEnvelope(wrapped, _) if(Std.is(wrapped, Envelope)): wrapped.message();
            case _: msg;
        };

        var destinations = applyRoute(msg.sender(), msg.message());

        // Note (Simon) : Haxe issue.
        // We have to do it this way, as we're not allowed to call the super in a local function.
        while(destinations.nonEmpty()) {
            var dest = destinations.head();

            switch(dest) {
                case Destination(_, s) if(s == self()): super.sendMessage(message);
                case Destination(sender, recipient):
                    // TODO (Simon) : Resize?
                    recipient.send(message, sender);
            }

            destinations = destinations.tail();
        }
    }

    public function routees() : List<ActorRef> return _routees;

    public function routeeProvider() : RouteeProvider return _routeeProvider;

    private function routerConfig() : RouterConfig return _props.router();
}

class RoutedActorCellCreator implements Creator {

    public function new() {}

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
            case _: routerReceive(value);
        }
    }

    override public function preRestart(reason : Errors, message : Option<AnyRef>) : Void {}

    public function routerReceive(value : AnyRef) : Void {

    }
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
