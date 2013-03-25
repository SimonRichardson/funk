package suites;

import massive.munit.TestSuite;

import funk.actors.ActorRefTest;
import funk.actors.ActorSystemTest;
import funk.actors.ActorTest;
import funk.actors.PropsTest;

class ActorsSuite extends TestSuite {

    public function new() {
        super();

        add(funk.actors.ActorRefTest);
        add(funk.actors.ActorSystemTest);
        add(funk.actors.ActorTest);
        add(funk.actors.PropsTest);
    }
}
