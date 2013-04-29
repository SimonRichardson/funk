package suites;

import massive.munit.TestSuite;

import funk.ds.CollectionTest;
import funk.ds.ParallelTest;
import funk.ds.immutable.ListTest;
import funk.ds.immutable.ListCollectionsTest;
import funk.ds.immutable.MapTest;

class DataStructuresSuite extends TestSuite {

    public function new() {
        super();

        add(funk.ds.CollectionTest);
        add(funk.ds.immutable.ListTest);
        add(funk.ds.immutable.ListCollectionsTest);
        add(funk.ds.immutable.MapTest);

        #if parallel
        add(funk.ds.ParallelTest);
        #end
    }
}
