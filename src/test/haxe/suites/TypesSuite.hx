package suites;

import massive.munit.TestSuite;

import funk.types.AnyTest;
import funk.types.EitherTest;
import funk.types.OptionTest;
import funk.types.Function0Test;
import funk.types.Function1Test;
import funk.types.Function2Test;
import funk.types.Function3Test;
import funk.types.Function4Test;
import funk.types.Function5Test;
import funk.types.PartialFunction1Test;
import funk.types.Predicate0Test;
import funk.types.Predicate1Test;
import funk.types.Predicate2Test;
import funk.types.Predicate3Test;
import funk.types.Predicate4Test;
import funk.types.Predicate5Test;
import funk.types.SelectorTest;
import funk.types.StringsTest;
import funk.types.Tuple1Test;
import funk.types.Tuple2Test;
import funk.types.Tuple3Test;
import funk.types.Tuple4Test;
import funk.types.Tuple5Test;
import funk.types.WildcardTest;

class TypesSuite extends TestSuite {

    public function new() {
        super();

        add(funk.types.AnyTest);

        add(funk.types.AttemptTest);
        add(funk.types.EitherTest);

        add(funk.types.OptionTest);

        add(funk.types.Function0Test);
        add(funk.types.Function1Test);
        add(funk.types.Function2Test);
        add(funk.types.Function3Test);
        add(funk.types.Function4Test);
        add(funk.types.Function5Test);

        add(funk.types.PartialFunction1Test);

        add(funk.types.Predicate0Test);
        add(funk.types.Predicate1Test);
        add(funk.types.Predicate2Test);
        add(funk.types.Predicate3Test);
        add(funk.types.Predicate4Test);
        add(funk.types.Predicate5Test);

        add(funk.types.SelectorTest);

        add(funk.types.StringsTest);

        add(funk.types.Tuple1Test);
        add(funk.types.Tuple2Test);
        add(funk.types.Tuple3Test);
        add(funk.types.Tuple4Test);
        add(funk.types.Tuple5Test);

        add(funk.types.WildcardTest);
    }
}
