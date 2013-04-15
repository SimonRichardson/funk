package funk.actors;

import funk.futures.Promise;
import funk.types.AnyRef;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using funk.types.Option;
using massive.munit.Assert;
using funk.types.Attempt;
using funk.types.Any;
using funk.actors.patterns.ReactSupport;
using funk.reactives.Stream;

class StashActorTest {

    private var _system : ActorSystem;

    private var _actor : ActorRef;

    @Before
    public function setup() : Void {
        _system = ActorSystem.create('system');
        _actor = _system.actorOf(new Props(MockClass), "listener");
    }

    @Test
    public function calling_send_should_create_a_new_actorOf_which_is_not_null() : Void {
        var actual = [];
        var expected = [Item(3), Item(2), Item(1), Item(0)];

        _actor.react().foreach(function(value) {
            if(AnyTypes.isInstanceOf(value, Array)) {
                actual = cast value;
            }
        });

        _actor.send(Item(0));
        _actor.send(Item(1));
        _actor.send(Item(2));
        _actor.send(Item(3));
        
        actual.toString().areEqual(expected.toString());
    }
}

enum Items {
    Item(value : Int);
}

private class MockClass extends StashActor {

    public static var Actor : ActorRef = null;

    private var _stashed : Bool;

    private var _values : Array<Items>;

    public function new() {
        super();

        _values = [];
        _stashed = false;
    }

    override public function receive(value : AnyRef) : Void {
        switch(cast value) {
            case Item(v) if(v < 3 && !_stashed): stash();
            case Item(v) if(v == 0 && _stashed): 
                _values.push(value);
                sender().get().send(_values);
            case _ if(AnyTypes.isInstanceOf(value, Array)):
            case _: 
                _stashed = true;
                unstashAll();
                _values.push(value);
        }
    }
}
