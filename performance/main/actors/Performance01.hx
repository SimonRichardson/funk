package ;

import funk.actors.Actor;
import funk.actors.ActorSystem;
import funk.actors.Props;
import funk.reactives.Process;
import funk.types.Any;
import funk.io.logging.Log;
import funk.io.logging.outputs.TraceOutput;

using funk.types.Option;
using funk.actors.patterns.ReactSupport;
using funk.reactives.Stream;
using funk.actors.patterns.ReactSupport;

class Performance01 {

    public function new() {
    }

    public static function main() {
        trace('Start');

        var output = new TraceOutput();
        output.add(Log.init().streamOut());

        Process.start(Performance01.run, 2000);
    }

    public static function run() : Void {
        var system = ActorSystem.create('system');
        system.deadLetters().react().foreach(function(value) trace('Deadletters Received: $value'));

        var actor = system.actorOf(new Props(SimpleActor), 'simples');

        //var simple = new SimpleInvokable();

        var t = Process.stamp();

        for (i in 0...99999) actor.send(i);
        //for (i in 0...999999999) simple.invoke(i);

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

private class SimpleInvokable {

    public function new(){

    }

    public function invoke(value : AnyRef) : Void {}
}
