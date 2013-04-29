package suites;

import massive.munit.TestSuite;
import funk.ds.CollectionReducibleTest;
import funk.ds.immutable.ListReducibleTest;

class ReduciblesSuite extends TestSuite {

    public function new() {
        super();

        add(funk.ds.CollectionReducibleTest);
        add(funk.ds.immutable.ListReducibleTest);
    }
}
