package funk.tuple;

import funk.tuple.Tuple1;
import massive.munit.Assert;

using funk.tuple.Tuple1;
using massive.munit.Assert;

class Tuple1Test {

	@Test
	public function should_allow_creation_of_enum() : Void {
		tuple1(1).isNotNull();
	}

	@Test
	public function should_calling__1_is_not_null() : Void {
		tuple1(1)._1().isNotNull();
	}

	@Test
	public function should_calling__1_is_1() : Void {
		tuple1(1)._1().areEqual(1);
	}

}
