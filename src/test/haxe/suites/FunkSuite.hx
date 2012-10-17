package suites;

import massive.munit.TestSuite;

import funk.either.EitherTest;
import funk.option.NoneTest;
import funk.option.SomeTest;
import funk.product.Product1Test;
import funk.product.Product2Test;
import funk.product.Product3Test;
import funk.product.Product4Test;
import funk.product.Product5Test;
import funk.product.ProductIteratorTest;
import funk.product.ProductTest;
import funk.tuple.Tuple1Test;
import funk.tuple.Tuple2Test;
import funk.tuple.Tuple3Test;
import funk.tuple.Tuple4Test;
import funk.tuple.Tuple5Test;
import funk.tuple.TupleTest;

class FunkSuite extends TestSuite
{

	public function new()
	{
		super();

		add(funk.either.EitherTest);
		add(funk.option.NoneTest);
		add(funk.option.SomeTest);
		add(funk.product.Product1Test);
		add(funk.product.Product2Test);
		add(funk.product.Product3Test);
		add(funk.product.Product4Test);
		add(funk.product.Product5Test);
		add(funk.product.ProductIteratorTest);
		add(funk.product.ProductTest);
		add(funk.tuple.Tuple1Test);
		add(funk.tuple.Tuple2Test);
		add(funk.tuple.Tuple3Test);
		add(funk.tuple.Tuple4Test);
		add(funk.tuple.Tuple5Test);
		add(funk.tuple.TupleTest);
	}
}
