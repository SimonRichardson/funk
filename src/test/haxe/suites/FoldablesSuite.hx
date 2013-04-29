package suites;

import massive.munit.TestSuite;
import funk.ds.CollectionFoldableTest;
import funk.ds.immutable.ListFoldableTest;

class FoldablesSuite extends TestSuite {

    public function new() {
        super();

        add(funk.ds.CollectionFoldableTest);
        add(funk.ds.immutable.ListFoldableTest);
    }
}
