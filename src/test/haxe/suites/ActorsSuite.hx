package suites;

import massive.munit.TestSuite;

import funk.actors.ActorRefTest;
import funk.actors.ActorSystemTest;
import funk.actors.ActorTest;
import funk.actors.PropsTest;
import funk.actors.ReactorTest;
import funk.actors.patterns.ActSupportTest;
import funk.actors.patterns.AskSupportTest;
import funk.actors.patterns.WorkerActorSupportTest;

class ActorsSuite extends TestSuite {

    public function new() {
        super();

        add(funk.actors.ActorRefTest);
        add(funk.actors.ActorSystemTest);
        add(funk.actors.ActorTest);
        add(funk.actors.PropsTest);
        add(funk.actors.ReactorTest);

        add(funk.actors.patterns.ActSupportTest);
        add(funk.actors.patterns.AskSupportTest);
        add(funk.actors.patterns.WorkerActorSupportTest);
    }
}
