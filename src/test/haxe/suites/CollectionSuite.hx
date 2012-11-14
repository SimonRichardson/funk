package suites;

import massive.munit.TestSuite;

import funk.collections.immutable.ListTest;
import funk.collections.immutable.ListUtilTest;
import funk.collections.immutable.MapTest;
import funk.collections.immutable.NilListTest;
import funk.collections.immutable.NilMapTest;
import funk.collections.IteratorUtilTest;
import funk.collections.ListIteratorTest;
import funk.collections.mutable.ListTest;
import funk.collections.mutable.ListUtilTest;
import funk.collections.mutable.NilListTest;

class CollectionSuite extends TestSuite
{

	public function new()
	{
		super();

		add(funk.collections.immutable.ListTest);
		add(funk.collections.immutable.ListUtilTest);
		add(funk.collections.immutable.MapTest);
		add(funk.collections.immutable.NilListTest);
		add(funk.collections.immutable.NilMapTest);
		add(funk.collections.IteratorUtilTest);
		add(funk.collections.ListIteratorTest);
		add(funk.collections.mutable.ListTest);
		add(funk.collections.mutable.ListUtilTest);
		add(funk.collections.mutable.NilListTest);
	}
}
