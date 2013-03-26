package funk.actors;

import funk.futures.Promise;
import funk.types.AnyRef;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using massive.munit.Assert;
using funk.types.Option;
using funk.types.Attempt;

class ReactorTest {

    private var _system : ActorSystem;

    private var _actor : ActorRef;

    @Before
    public function setup() : Void {
        _system = ActorSystem.create('system');
        _actor = _system.actorOf(new Props(MockClass), "listener");
    }

    @Test
    public function calling_send_should_return_correct_sender() : Void {
        _actor.send("Hello", _actor);
    }
}

private class MockClass extends Reactor {

    public function new() {
        super();
    }
}
