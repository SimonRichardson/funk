package funk.actors.patterns;

import funk.futures.Promise;
import funk.types.AnyRef;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using massive.munit.Assert;
using funk.types.Option;
using funk.types.Attempt;
using funk.reactives.Stream;
using funk.actors.patterns.ActSupport;

class ActSupportTest {

    private var _system : ActorSystem;

    @Before
    public function setup() : Void {
        _system = ActorSystem.create('system');
    }

    @Test
    public function calling_act_support_will_call_ref() : Void {
        var actual = "nothing";
        var expected = "hello";

        var ref = _system.actor("listener")(new Act(function(value) {
            actual = value;
        }));

        ref.send(expected, ref);

        actual.areEqual(expected);
    }
}
