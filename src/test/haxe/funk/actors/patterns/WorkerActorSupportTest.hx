package funk.actors.patterns;

import funk.futures.Promise;
import funk.types.AnyRef;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using massive.munit.Assert;
using funk.types.Option;
using funk.types.Attempt;
using funk.reactives.Stream;
using funk.actors.patterns.WorkerActorSupport;

class WorkerActorSupportTest {

    private var _system : ActorSystem;

    @Before
    public function setup() : Void {
        _system = ActorSystem.create('system');
    }

    @Test
    public function calling_worker_support_will_call_ref() : Void {
        var actual = "nothing";
        var expected = 1222;

        trace("here");

        var ref = _system.actorOf(new Props(MockClass), 'listener');

        var promise = ref.parallel(function(data : AnyRef) : AnyRef {
            var sum : Int = 0;
            for(i in data.from...data.to) {
                sum += i;
            }
            return sum;
        }, {from:0, to:1000});

        promise.when(function(attempt) {
            trace(attempt);
            switch(attempt) {
                case Success(v): actual = v;
                case _: Assert.fail("Failed if called");
            }
        });

        actual.areEqual(expected);
    }
}

private class MockClass extends Actor {

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {
        trace("WTF");
        trace(value);
    }
}
