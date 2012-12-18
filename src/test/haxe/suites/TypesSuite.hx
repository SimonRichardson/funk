package suites;

import massive.munit.TestSuite;

import funk.types.EitherTest;
import funk.types.OptionTest;
import funk.types.Function0Test;
import funk.types.Function1Test;
import funk.types.LazyTest;
import funk.types.Predicate0Test;
import funk.types.Predicate1Test;
import funk.types.Predicate2Test;
import funk.types.Predicate3Test;
import funk.types.Predicate4Test;
import funk.types.Predicate5Test;
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

		add(funk.types.EitherTest);

		add(funk.types.OptionTest);

		add(funk.types.Function0Test);
		add(funk.types.Function1Test);

		add(funk.types.LazyTest);

		add(funk.types.Predicate0Test);
		add(funk.types.Predicate1Test);
		add(funk.types.Predicate2Test);
		add(funk.types.Predicate3Test);
		add(funk.types.Predicate4Test);
		add(funk.types.Predicate5Test);

		add(funk.types.Tuple1Test);
		add(funk.types.Tuple2Test);
		add(funk.types.Tuple3Test);
		add(funk.types.Tuple4Test);
		add(funk.types.Tuple5Test);
	}
}
