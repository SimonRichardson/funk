package funk.actors;

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
        //Std.is(ref, ActorRef).isTrue();
    }
}

class MockClass extends Actor {

    public function new() {
        super();
    }
}
