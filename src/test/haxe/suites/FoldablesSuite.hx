package suites;

import massive.munit.TestSuite;
import funk.collections.CollectionFoldableTest;
import funk.collections.immutable.ListFoldableTest;

class FoldablesSuite extends TestSuite {

    public function new() {
        super();

        add(funk.collections.CollectionFoldableTest);
        add(funk.collections.immutable.ListFoldableTest);
    }
}
