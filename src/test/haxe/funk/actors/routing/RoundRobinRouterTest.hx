package funk.actors.routing;

import funk.actors.ActorSystem;
import funk.actors.dispatch.EnvelopeMessage;
import funk.actors.routing.RoundRobinRouter;
import funk.types.Any;
import funk.types.extensions.Strings;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using massive.munit.Assert;

class RoundRobinRouterTest {

    private var _system : ActorSystem;

    @Before
    public function setup() {
        _system = ActorSystem.create("system");
    }

    @Test
    public function when_using_a_actorOf_with_robin_router_should_return_actor() : Void {
        var actor = _system.actorOf(new Props(MockClass).withRouter(new RoundRobinRouter(4)), "robin");
        actor.isNotNull();
        actor.send('Hello');
        actor.send('Hello');
        actor.send('Hello');
        actor.send('Hello');
        actor.send(Broadcast('world'), actor);
    }
}

private class MockClass extends Actor {

    private var _uid : String;

    public function new() {
        super();

        _uid = Strings.uuid();
    }

    override public function receive(value : AnyRef) : Void {
        trace('${_uid} - ${value}');
    }
}
