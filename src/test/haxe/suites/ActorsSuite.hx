package suites;

import massive.munit.TestSuite;

import funk.actors.ActorRefTest;
import funk.actors.ActorSystemTest;
import funk.actors.ActorTest;
import funk.actors.PropsTest;
import funk.actors.ReactorTest;
import funk.actors.events.EventStreamTest;
import funk.actors.patterns.ActSupportTest;
import funk.actors.patterns.AskSupportTest;
import funk.actors.patterns.MVCSupportTest;
import funk.actors.patterns.WorkerActorSupportTest;
import funk.actors.routing.RoundRobinRouterTest;

import funk.io.logging.Log;
import funk.io.logging.outputs.TraceOutput;

class ActorsSuite extends TestSuite {

    public function new() {
        super();

        var output = new TraceOutput();
        output.add(Log.init().streamOut());

        add(funk.actors.ActorRefTest);
        add(funk.actors.ActorSystemTest);
        add(funk.actors.ActorTest);
        add(funk.actors.PropsTest);
        add(funk.actors.ReactorTest);

        add(funk.actors.events.EventStreamTest);

        add(funk.actors.patterns.ActSupportTest);
        add(funk.actors.patterns.AskSupportTest);
        add(funk.actors.patterns.MVCSupportTest);
        add(funk.actors.patterns.WorkerActorSupportTest);

        add(funk.actors.routing.RoundRobinRouterTest);
    }
}
