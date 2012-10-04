import massive.munit.TestSuite;

import funk.product.ProductTest;
import funk.tuple.Tuple1Test;
import funk.tuple.Tuple2Test;
import funk.tuple.Tuple3Test;
import funk.tuple.Tuple4Test;
import funk.tuple.Tuple5Test;
import funk.tuple.TupleTest;

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
		add(funk.tuple.Tuple2Test);
		add(funk.tuple.Tuple3Test);
		add(funk.tuple.Tuple4Test);
		add(funk.tuple.Tuple5Test);
		add(funk.tuple.TupleTest);
	}
}
