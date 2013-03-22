package suites;

import massive.munit.TestSuite;
import funk.collections.CollectionReducibleTest;
import funk.collections.immutable.ListReducibleTest;

class ReduciblesSuite extends TestSuite {

    public function new() {
        super();

        add(funk.collections.CollectionReducibleTest);
        add(funk.collections.immutable.ListReducibleTest);
    }
}
