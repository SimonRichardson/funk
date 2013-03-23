package funk.actors;

import funk.futures.Promise;
import funk.types.AnyRef;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using massive.munit.Assert;
using funk.types.Attempt;

class ActorRefTest {

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
        MockClass.Sender.areEqual(_actor);
    }
}

private class MockClass extends Actor {

    public static var Sender : ActorRef = null;

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {
        Sender = sender();
    }
}
