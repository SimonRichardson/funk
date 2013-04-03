package ;

import funk.actors.Actor;
import funk.actors.ActorSystem;
import funk.actors.Props;
import funk.types.AnyRef;

using funk.types.Option;
using funk.actors.patterns.ReactSupport;
using funk.reactives.Stream;

class Example01 {

    public function new() {
        var system = ActorSystem.create('system');
        var actor = system.actorOf(new Props(SimpleActor), 'simples');
        actor.react().foreach(function(value : AnyRef) {
            trace(value);
        });
        actor.send('hello', actor);
    }

    public static function main() {
        new Example01();
    }
}

private class SimpleActor extends Actor {

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {
        var s = sender().get();
        switch(value) {
            case _ if(value == 'hello'): s.send('world', s);
            case _:
        }
    }
}
