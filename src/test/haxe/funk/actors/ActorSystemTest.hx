package funk.actors;

import funk.futures.Promise;
import funk.types.AnyRef;
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

    @Test
    public function calling_actorOf_and_telling_the_actor_some_info_should_be_called() : Void {
        var expected = "hello";
        var ref = _system.actorOf(new Props(MockClass), 'name');
        ref.send(expected, ref);
        MockClass.Actual.areEqual(expected);
    }

    @Test
    public function calling_toString_on_actor_path_should_return_valid_path() : Void {
        var path = _system.actorPath().toString();
        path.areEqual('funk://system/user/');
    }
}

class MockClass extends Actor {

    public static var Actual : AnyRef;

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {
        Actual = value;
    }
}
