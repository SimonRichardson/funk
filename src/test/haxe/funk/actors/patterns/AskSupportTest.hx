package funk.actors.patterns;

import funk.futures.Promise;
import funk.types.AnyRef;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using massive.munit.Assert;
using funk.types.Option;
using funk.types.Attempt;
using funk.reactives.Stream;
using funk.actors.patterns.AskSupport;

class AskSupportTest {

    private var _system : ActorSystem;

    @Before
    public function setup() : Void {
        _system = ActorSystem.create('system');
    }

    @Test
    public function calling_ask_support_will_call_ref() : Void {
        var actual = "nothing";
        var expected = "pong";

        var ref = _system.actorOf(new Props(MockClass), 'listener');

        var promise = ref.ask("ping", ref);
        promise.when(function(attempt) {
            switch(attempt) {
                case Success(v): actual = v;
                case _: Assert.fail("Failed if called");
            }
        });

        actual.areEqual(expected);
    }
}

class MockClass extends Actor {

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {
        var receiver = sender().getOrElse(function() return context().system().deadLetters());

        switch(value) {
            case _ if(value == 'ping'): receiver.send('pong', receiver);
            case _: receiver.send(Failure(Error('Invalid message $value')), receiver);
        }
    }
}
