package funk.actors;

import unit.Asserts;
import funk.futures.Promise;
import funk.types.Any;
import funk.types.extensions.EnumValues;
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

    private var _filledExpected : Array<Int>;

    @Before
    public function setup() : Void {
        _filledExpected = [for(x in 0...999) x];
    
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

        AnyTypes.isInstanceOf(actual, ActorRef).isTrue();
    }

    @AsyncTest
    public function calling_send_on_actor_ref_should_result_in_correct_number_of_arguments_sent(asyncFactory : AsyncFactory) : Void {
        var actual = [];
        var total = _filledExpected.length;

        var handler:Dynamic = asyncFactory.createHandler(this, function() {
            Asserts.areIterablesEqual(actual, _filledExpected);
        }, 500);

        var actor = _system.actorOf(new Props(EchoActor), "echo");
        actor.react().foreach(function(msg) {
            switch(msg) {
                case _ if(AnyTypes.isValueOf(msg, Response)): 
                    actual.push(ResponseType.value(msg));
                    if (actual.length >= total) handler();
                case _:
            }
        });

        for(i in 0...total) {
            actor.send(Send(i));
        }
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

private class EchoActor extends Actor {

    public function new() {
        super();
    }

    override public function receive(msg : AnyRef) : Void {
        switch (msg) {
            case _ if(AnyTypes.isValueOf(msg, Request)):
                var recipient = sender().get();
                recipient.send(Ack(RequestType.value(msg)), recipient);
            case _: // Do nothing.
        }
        
    }
}

private enum Request<T> {
    Send(value : T);
}

private enum Response<T> {
    Ack(value : T);
}

private class RequestType {

    public static function value<T>(val : Request<T>) : T return EnumValues.getValueByIndex(val, 0);
}

private class ResponseType {

    public static function value<T>(val : Response<T>) : T return EnumValues.getValueByIndex(val, 0);
}
