package funk.actors;

import funk.futures.Promise;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using massive.munit.Assert;
using funk.types.Attempt;

class ActorSystemTest {

    private static var TIMEOUT : Int = 500;

    private var _system : ActorSystem;

    @Before
    public function setup() : Void {
        _system = ActorSystem.create('system');
    }

    @Test
    public function calling_actorOf_should_return_ActorRef_that_is_not_null() : Void {
        _system.actorOf(new Props(MockClass), "listener").isNotNull();
    }

    @Test
    public function calling_actorOf_should_return_valid_ActorRef() : Void {
        var ref = _system.actorOf(new Props(MockClass), "listener");
        Std.is(ref, ActorRef).isTrue();
    }

    @Test
    public function calling_actorOf_should_return_valid_ActorRef_path() : Void {
        var rand = Std.int(Math.random() * 9999).toString();
        var ref = _system.actorOf(new Props(MockClass), 'name$rand');
        ref.path().toString().areEqual('funk://system/user/name$rand/');
    }

    @Test
    public function calling_actorOf_multiple_times_should_return_valid_ActorRef_path() : Void {
        for (i in 0...10) {
            var ref = _system.actorOf(new Props(MockClass), 'name$i');
            ref.path().toString().areEqual('funk://system/user/name$i/');
        }
    }


    /*
    @AsyncTest
    public function calling_actorOf_should_return_valid_ActorRef(asyncFactory : AsyncFactory) : Void {
        var actual = null;

        var handler = asyncFactory.createHandler(this, function() {
            Std.is(actual, ActorRef).isTrue();
        }, TIMEOUT);

        var ref = _system.actorOf(new Props(MockClass), "listener");
        ref.when(function(attempt) {
            switch(attempt) {
                case Success(actor): actual = actor;
                case _: Assert.fail("Failed if called");
            }

            handler();
        });
    }
    */

    @Test
    public function calling_toString_on_actor_path_should_return_valid_path() : Void {
        var path = _system.actorPath().toString();
        path.areEqual('funk://system/user/');
    }
}

class MockClass extends Actor {

    public function new() {
        super();
    }
}
