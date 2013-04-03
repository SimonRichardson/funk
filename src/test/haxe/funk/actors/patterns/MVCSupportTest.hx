package funk.actors.patterns;

import funk.futures.Promise;
import funk.types.AnyRef;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using massive.munit.Assert;
using funk.types.Option;
using funk.types.Attempt;
using funk.reactives.Stream;
using funk.actors.patterns.ReactSupport;
using funk.actors.patterns.MVCSupport;

class MVCSupportTest {

    private var _system : ActorSystem;

    @Before
    public function setup() : Void {
        _system = ActorSystem.create('system');
        _system.deadLetters().react().foreach(function(value) Assert.fail("Failed if called"));
    }

    @Test
    public function calling_ask_support_will_call_ref() : Void {
        var model = _system.actorOf(new Props().withCreator(new ModelCreator()), 'model');
        var view = _system.actorOf(new Props().withCreator(new ViewCreator(model)), 'view');
        var controller = _system.actorOf(new Props().withCreator(new ControllerCreator(model)), 'controller');

        var actual = '';
        var expected = 'hello';
        
        view.react().foreach(function(value) {
            var note : Notifications = cast value;
            switch(note) {
                case TheState(_, val): actual = val;
                case _:
            }
            return true;
        });

        controller.send(expected);

        actual.areEqual(expected);
    }
}
