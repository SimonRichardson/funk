package funk.actors;

import funk.futures.Promise;
import funk.types.AnyRef;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using massive.munit.Assert;
using funk.types.Attempt;

class ActorTest {

    private var _system : ActorSystem;

    private var _actor : ActorRef;

    @Before
    public function setup() : Void {
        _system = ActorSystem.create('system');
        _actor = _system.actorOf(new Props(MockClass), "listener");
        trace(_system.printTree());
    }

    @Test
    public function calling_send_should_create_a_new_actorOf_which_is_not_null() : Void {
        _actor.send(GetActorOf, _actor);
        MockClass.Actor.isNotNull();
    }

    @Test
    public function calling_send_should_create_a_new_actorOf() : Void {
        _actor.send(GetActorOf, _actor);
        Std.is(MockClass.Actor, ActorRef).isTrue();
    }
}

private enum Tests {
    GetActorOf;
}

private class MockClass extends Actor {

    public static var Actor : ActorRef = null;

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {
        var tests : Tests = cast value;
        switch(tests) {
            case GetActorOf: Actor = actorOf(new Props(MockClass), "test");
        }
    }
}
