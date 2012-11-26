package suites;

import massive.munit.TestSuite;

import funk.collections.immutable.ListTest;

class CollectionsSuite extends TestSuite
{

	public function new()
	{
		super();

		add(funk.collections.immutable.ListTest);
	}
}
