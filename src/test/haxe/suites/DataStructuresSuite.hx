package suites;

import massive.munit.TestSuite;

import funk.ds.CollectionTest;
import funk.ds.CollectionDropableTest;
import funk.ds.CollectionFoldableTest;
import funk.ds.CollectionReducibleTest;
import funk.ds.ParallelTest;
import funk.ds.immutable.ListTest;
import funk.ds.immutable.ListCollectionsTest;
import funk.ds.immutable.MapTest;

class DataStructuresSuite extends TestSuite {

    public function new() {
        super();

        add(funk.ds.CollectionTest);
        add(funk.ds.CollectionDropableTest);
        add(funk.ds.CollectionFoldableTest);
        add(funk.ds.CollectionReducibleTest);

        add(funk.ds.immutable.ListTest);
        add(funk.ds.immutable.ListCollectionsTest);
        add(funk.ds.immutable.ListDropableTest);
        add(funk.ds.immutable.ListFoldableTest);
        add(funk.ds.immutable.ListReducibleTest);

        add(funk.ds.immutable.MapTest);

        #if parallel
        add(funk.ds.ParallelTest);
        #end
    }
}
