package funk.actors;

import funk.actors.ActorSystem;
import funk.types.Any;
import massive.munit.async.AsyncFactory;

using massive.munit.Assert;
using funk.actors.patterns.ReactSupport;
using funk.reactives.Stream;

class SchedulerTest {

    inline public static var TIMEOUT : Int = 500;

    private var _system : ActorSystem;

    @Before
    public function setup() : Void {
        _system = ActorSystem.create("system");
    }

    @AsyncTest
    public function calling_scheduleOnce_should_trigger_a_message(asyncFactory : AsyncFactory) : Void {
        var actual = '';
        var expected = 'Hello, world!';

        var handler : Dynamic = asyncFactory.createHandler(this, function() {
            actual.areEqual(expected);
        }, TIMEOUT);

        var actor = _system.actorOf(new Props(MockClass), "listener");
        actor.react().foreach(function(value) {
            actual = value;
            handler();
        });
        _system.scheduler().scheduleOnce(0, 10, actor, expected);
    }
}

private class MockClass extends Actor {

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {
    }
}
