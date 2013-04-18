package funk.actors.events;

import funk.futures.Promise;
import funk.types.AnyRef;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using massive.munit.Assert;
using funk.types.Option;
using funk.types.Attempt;
using funk.types.Any;

class EventStreamTest {

    private var _system : ActorSystem;

    @Before
    public function setup() : Void {
        _system = ActorSystem.create('system');
    }

    @Test
    public function calling_send_should_return_correct_sender() : Void {
        var ping = _system.actorOf(new Props(PingActor), "ping");
        var pong = _system.actorOf(new Props(PongActor), "pong");

        _system.eventStream().subscribe(ping, Pong);
        _system.eventStream().subscribe(pong, Ping);

        ping.send("start");
    }
}

private class Ping {
    public function new(){}
}
private class Pong {
    public function new(){}
}

private class PingActor extends Actor {

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {
        switch(value) {
            case _ if(value == "start"): context().system().eventStream().publish(new Ping());
            case _ if(AnyTypes.isInstanceOf(value, Pong)): trace("Pong");
            case _:
        }
    }
}

private class PongActor extends Actor {

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {
        switch(value) {
            case _ if(AnyTypes.isInstanceOf(value, Ping)):
                trace("Ping");
                context().system().eventStream().publish(new Pong());
            case _:
        }
    }
}

