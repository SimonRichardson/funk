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

    @AsyncTest
    public function calling_worker_support_will_call_ref(asyncFactory : AsyncFactory) : Void {
        var actual = -1;
        var expected = 499500;

        var ref = _system.actorOf(new Props(MockClass), 'listener');

        var promise = ref.parallel(function(data : AnyRef) : AnyRef {
            var sum : Int = 0;
            for(i in data.from...data.to) {
                sum += i;
            }
            return sum;
        }, {from : 0, to : 1000});


        var handler : Dynamic = asyncFactory.createHandler(this, function() {
            #if js
            actual.areEqual(expected);
            #end
        }, 300);

        promise.when(function(attempt) {
            switch(attempt) {
                case Success(v): actual = v;
                case _: Assert.fail("Failed if called");
            }

            handler();
        });

        #if !js
        handler();
        #end
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
