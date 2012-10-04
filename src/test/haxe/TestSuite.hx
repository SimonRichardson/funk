import massive.munit.TestSuite;

import funk.product.ProductTest;
import funk.tuple.Tuple1Test;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(funk.product.ProductTest);
		add(funk.tuple.Tuple1Test);
	}
}
