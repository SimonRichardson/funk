package suites;

import massive.munit.TestSuite;

import funk.collections.CollectionTest;
import funk.collections.immutable.ListTest;
import funk.collections.immutable.ListCollectionsTest;

class CollectionsSuite extends TestSuite {

	public function new() {
		super();

		add(funk.collections.CollectionTest);
		add(funk.collections.immutable.ListTest);
		add(funk.collections.immutable.ListCollectionsTest);
	}
}
