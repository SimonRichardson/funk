package funk.actors.routing;

import funk.actors.dispatch.EnvelopeMessage;
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

using funk.actors.dispatch.EnvelopeMessage;
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

    override public function toString() return '[RoutedActorRef (path=${path()})]';
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
        _routeeProvider = _props.router().createRouteeProvider(this, _routedProps.withRouter(new NoRouter()));

        _routees = Nil;
    }

    override public function init(uid : String, ?sendSupervise : Bool = true) : Void {
        _route = routerConfig().createRoute(_routeeProvider);

        super.init(uid, sendSupervise);
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

    override public function sendMessage(msg : EnvelopeMessage) : Void {
        var message : EnvelopeMessage = switch (msg) {
            case RouterEnvelope(routerMessage, _):
                switch(Type.typeof(routerMessage)) {
                    case TEnum(e) if(e == EnvelopeMessage): routerMessage;
                    case _: msg;
                }
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

    override public function toString() return '[RoutedActorCell (path=${self().path()})]';
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
            case _ if(AnyTypes.isInstanceOf(c, RoutedActorCell)): cast c;
            case _: Funk.error(ActorError('Router actor can only be used in RoutedActorRef, not in ${c}'));
        }
    }

    override public function receive(value : AnyRef) : Void {
        switch(value) {
            case _ if(AnyTypes.isInstanceOf(value, ActorMessages)):
                var actorMsg : ActorMessages = cast value;
                switch(actorMsg) {
                    case Terminated(child):
                        _ref.removeRoutees(Nil.prepend(child));
                        if(_ref.routees().isEmpty()) context().stop();
                    case _: routerReceive(value);
                }
            case _: routerReceive(value);
        }
    }

    override public function preRestart(reason : Errors, message : Option<AnyRef>) : Void {}

    public function routerReceive(value : AnyRef) : Void {

    }

    override public function toString() return '[Router (path=${path()})]';
}

interface RouterConfig {

    function createRoute(routeeProvider : RouteeProvider) : Route;

    function createActor() : Actor;

    function createRouteeProvider(context : ActorContext, routeeProps : Props) : RouteeProvider;

    function toString() : String;
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

    public function toString() return '[NoRouter]';
}

class AccessRouter implements RouterConfig {

    private var _nrOfInstances : Int;

    private var _routees : List<ActorPath>;

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
                currentRoutees.get(access(next++, currentRoutees.size())).get();
            }
        }

        function createDestinations(sender : ActorRef) : List<Destination> {
            return Nil.prepend(Destination(sender, getNext()));
        }

        return function(sender : ActorRef, message : AnyRef) : List<Destination> {
            return switch (Type.typeof(message)) {
                case TEnum(e) if (e == EnvelopeMessage):
                    var envelope : EnvelopeMessage = cast message;
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

    private function access(offset : Int, size : Int) : Int return 0;

    public function toString() return '[AccessRouter (nrOfInstances=${_nrOfInstances})]';
}
