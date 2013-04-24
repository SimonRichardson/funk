package funk.actors;

import funk.futures.Promise;
import funk.types.Any;
import funk.types.AnyRef;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using massive.munit.Assert;
using funk.types.Attempt;
using funk.types.Option;
using funk.reactives.Stream;
using funk.actors.patterns.ReactSupport;

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
        var actual = null;

        _actor.react().foreach(function(actor) {
            actual = actor;
        });
        _actor.send(GetActorOf);

        actual.isNotNull();
    }

    @Test
    public function calling_send_should_create_a_new_actorOf() : Void {
        var actual = null;

        _actor.react().foreach(function(actor) {
            actual = actor;
        });
        _actor.send(GetActorOf);

        AnyTypes.isInstanceOf(actual, ActorRef).isTrue();
    }

    @Test
    public function calling_send_which_will_fail_should_recover_and_return_a_valid_actor() : Void {
        var actual = null;

        _actor.send(FailWithError);

        _actor.react().foreach(function(actor) {
            actual = actor;
        });

        _actor.send(GetActorOf);

        actual.isNotNull();
    }

    @Test
    public function calling_send_which_will_fail_should_recover_and_return_a_actorRef() : Void {
        var actual = null;

        _actor.send(FailWithError);

        _actor.react().foreach(function(actor) {
            actual = actor;
        });

        _actor.send(GetActorOf);

        Std.is(actual, ActorRef).isTrue();
    }
}

private enum Tests {
    GetActorOf;
    FailWithError;
}

private class MockClass extends Actor {

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {
        switch(value) {
            case _ if(AnyTypes.isValueOf(value, GetActorOf)):
                sender().get().send(actorOf(new Props(MockClass), "test"));
            case _ if(AnyTypes.isValueOf(value, FailWithError)):
                trace('Fail with error');
                throw "Fail with error";
        }
    }
}
