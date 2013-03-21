package funk.actors;

import funk.futures.Promise;

using massive.munit.Assert;

class ActorSystemTest {

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
        Std.is(ref, Promise).isTrue();
    }

    @Test
    public function calling_toString_on_actor_path_should_return_valid_path() : Void {
        var path = _system.actorPath().toString();
        path.areEqual('funk://system');
    }
}

class MockClass extends Actor {

    public function new() {
        super();
    }
}
