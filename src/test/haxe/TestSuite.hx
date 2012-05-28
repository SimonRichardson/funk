import massive.munit.TestSuite;

import funk.collections.immutable.ListTest;
import funk.collections.immutable.NilTest;
import funk.collections.mutable.ListTest;
import funk.collections.mutable.NilTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(funk.collections.immutable.ListTest);
		add(funk.collections.immutable.NilTest);
		add(funk.collections.mutable.ListTest);
		add(funk.collections.mutable.NilTest);
	}
}
