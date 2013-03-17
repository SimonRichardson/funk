package suites;

import massive.munit.TestSuite;

import funk.actors.ActorSystemTest;

class ActorsSuite extends TestSuite {

    public function new() {
        super();

        add(funk.actors.ActorSystemTest);
    }
}
