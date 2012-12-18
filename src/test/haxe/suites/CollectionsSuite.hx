package suites;

import massive.munit.TestSuite;

import funk.collections.CollectionsTest;
import funk.collections.ParallelTest;
import funk.collections.immutable.ListTest;
import funk.collections.immutable.ListCollectionsTest;

class CollectionsSuite extends TestSuite
{

	public function new()
	{
		super();

		add(funk.collections.CollectionsTest);
		add(funk.collections.immutable.ListTest);
		add(funk.collections.immutable.ListCollectionsTest);

		#if parallel
		add(funk.collections.ParallelTest);
		#end
	}
}
