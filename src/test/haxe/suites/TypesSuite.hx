package suites;

import massive.munit.TestSuite;

import funk.types.LazyTest;
import funk.types.EitherTest;
import funk.types.OptionTest;
import funk.types.Tuple1Test;
import funk.types.Tuple2Test;
import funk.types.Tuple3Test;
import funk.types.Tuple4Test;
import funk.types.Tuple5Test;

class TypesSuite extends TestSuite
{

	public function new()
	{
		super();

		add(funk.types.LazyTest);

		add(funk.types.EitherTest);

		add(funk.types.OptionTest);

		add(funk.types.Tuple1Test);
		add(funk.types.Tuple2Test);
		add(funk.types.Tuple3Test);
		add(funk.types.Tuple4Test);
		add(funk.types.Tuple5Test);
	}
}
