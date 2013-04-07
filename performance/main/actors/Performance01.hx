package ;

import funk.actors.Actor;
import funk.actors.ActorSystem;
import funk.actors.Props;
import funk.reactives.Process;
import funk.types.AnyRef;

using funk.types.Option;
using funk.actors.patterns.ReactSupport;
using funk.reactives.Stream;

class Performance01 {

    public function new() {
        var system = ActorSystem.create('system');
        var actor = system.actorOf(new Props(SimpleActor), 'simples');

        for (i in 0...999) {
            actor.send('hello ${i}', actor);
        }
    }

    public static function main() {
        new Performance01();
    }
}

private class SimpleActor extends Actor {

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {}
}
