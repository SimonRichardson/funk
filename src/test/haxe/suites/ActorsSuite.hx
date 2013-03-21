package suites;

import massive.munit.TestSuite;

import funk.actors.ActorSystemTest;
import funk.actors.PropsTest;

class ActorsSuite extends TestSuite {

    public function new() {
        super();

        add(funk.actors.ActorSystemTest);
        add(funk.actors.PropsTest);
    }
}
