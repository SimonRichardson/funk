package funk.actors;

import funk.futures.Promise;
import funk.types.Any;
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
    }

    @Test
    public function calling_send_should_create_a_new_actorOf_which_is_not_null() : Void {
        _actor.send(GetActorOf);
        MockClass.Actor.isNotNull();
    }

    @Test
    public function calling_send_should_create_a_new_actorOf() : Void {
        _actor.send(GetActorOf);
        AnyTypes.isInstanceOf(MockClass.Actor, ActorRef).isTrue();
    }

    @Test
    public function calling_send_which_will_fail_should_recover() : Void {
        _actor.send(FailWithError);
    }
}

private enum Tests {
    GetActorOf;
    FailWithError;
}

private class MockClass extends Actor {

    public static var Actor : ActorRef = null;

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {
        switch(cast value) {
            case GetActorOf: Actor = actorOf(new Props(MockClass), "test");
            case FailWithError: 
                trace('Fail with error');
                throw "Fail with error";
        }
    }
}
