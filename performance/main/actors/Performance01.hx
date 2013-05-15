package ;

import funk.actors.Actor;
import funk.actors.ActorSystem;
import funk.actors.Props;
import funk.reactives.Process;
import funk.types.Any;

using funk.types.Option;
using funk.actors.patterns.ReactSupport;
using funk.reactives.Stream;

class Performance01 {

    public function new() {
    }

    public static function main() {
        trace('Start');

        Process.start(Performance01.run, 2000);
    }

    public static function run() : Void {
        var system = ActorSystem.create('system');
        var actor = system.actorOf(new Props(SimpleActor), 'simples');

        var t = Process.stamp();

        for (i in 0...99999) actor.send(i, actor);

        trace((Process.stamp() - t) / 1000 + ' seconds');

        // Process.start(Performance01.run, 2000);
    }
}

private class SimpleActor extends Actor {

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {}
}
