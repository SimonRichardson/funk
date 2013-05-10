package funk.actors.patterns;

import funk.futures.Promise;
import funk.types.Any;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using massive.munit.Assert;
using funk.types.Option;
using funk.types.Attempt;
using funk.types.PartialFunction1;
using funk.reactives.Stream;
using funk.actors.patterns.ReactSupport;
using funk.actors.patterns.MVCSupport;

class MVCSupportTest {

    private var _system : ActorSystem;

    @Before
    public function setup() : Void {
        _system = ActorSystem.create('system');
        _system.deadLetters().react().foreach(function(value) trace('Deadletters Received: $value'));
    }

    @Test
    public function calling_ask_support_will_call_ref() : Void {
        var facade = _system.actorOf(new Props().withCreator(new FacadeCreator()), "facade");
        var view = _system.actorFor(facade.path().child("view")).get();

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

        facade.send(expected);

        actual.areEqual(expected);
    }

    @Test
    public function calling_ask_support_will_guard_call_ref() : Void {
        var guard = Partial1(function(x) return x == 'hello', function(x) return x).fromPartial();
        var controller = new GuardedControllerProps(GuardedController).withGuard(guard);

        var creator = new FacadeCreator(new Props(Model), new Props(View), controller);
        
        var facade = _system.actorOf(new Props().withCreator(creator), "facade");
        var view = _system.actorFor(facade.path().child("view")).get();

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

        facade.send(expected);
        facade.send('world');

        actual.areEqual(expected);
    }
}
