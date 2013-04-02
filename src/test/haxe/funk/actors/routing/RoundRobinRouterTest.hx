package funk.actors.routing;

import funk.actors.ActorSystem;
import funk.actors.dispatch.Envelope;
import funk.actors.routing.RoundRobinRouter;
import funk.types.AnyRef;
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
        
        trace(actor);

        actor.isNotNull();

        cast(actor).sendMessage(Broadcast('hello'));
    }
}

private class MockClass extends Actor {

    public function new() {
        super();

        trace("HERE");
    }

    override public function receive(value : AnyRef) : Void {
        trace(value);
    }
}
