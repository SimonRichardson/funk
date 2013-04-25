package suites;

import massive.munit.TestSuite;

import funk.collections.CollectionTest;
import funk.collections.ParallelTest;
import funk.collections.immutable.ListTest;
import funk.collections.immutable.ListCollectionsTest;
import funk.collections.immutable.MapTest;

class CollectionsSuite extends TestSuite {

    public function new() {
        super();

        add(funk.collections.CollectionTest);
        add(funk.collections.immutable.ListTest);
        add(funk.collections.immutable.ListCollectionsTest);
        add(funk.collections.immutable.MapTest);

        #if parallel
        add(funk.collections.ParallelTest);
        #end
    }
}
