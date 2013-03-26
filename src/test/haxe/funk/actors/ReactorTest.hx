package funk.actors;

import funk.futures.Promise;
import funk.types.AnyRef;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using massive.munit.Assert;
using funk.types.Option;
using funk.types.Attempt;
using funk.reactives.Stream;

class ReactorTest {

    private var _system : ActorSystem;

    private var _actor : ActorRef;

    @Before
    public function setup() : Void {
        _system = ActorSystem.create('system');
        _actor = _system.actorOf(new Props(MockClass), "listener");
    }

    @Test
    public function calling_send_to_self_should_return_via_react() : Void {
        var actual = 'nothing';
        var expected = 'Hello';

        _actor.send(expected, _actor);
        
        MockClass.Actual.areEqual(expected);
    }
}

private class MockClass extends Reactor {

    public static var Actual : AnyRef;

    public function new() {
        super();

        react().foreach(function(any) Actual = any);
    }
}
