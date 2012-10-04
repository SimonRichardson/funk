package funk.tuple;

import funk.errors.NoSuchElementError;
import funk.tuple.Tuple2;
import massive.munit.Assert;

using funk.tuple.Tuple2;
using massive.munit.Assert;

class Tuple2Test {

	@Test
	public function should_allow_creation_of_enum() : Void {
		tuple2(1, "a").isNotNull();
	}

	@Test
	public function should_calling__1_is_not_null() : Void {
		tuple2(1, "a")._1().isNotNull();
	}

	@Test
	public function should_calling__2_is_not_null() : Void {
		tuple2(1, "a")._2().isNotNull();
	}

	@Test
	public function should_calling__1_is_1() : Void {
		tuple2(1, "a")._1().areEqual(1);
	}

	@Test
	public function should_calling__2_is_a() : Void {
		tuple2(1, "a")._2().areEqual("a");
	}

	@Test
	public function should_calling_instance_return_not_null() : Void {
		tuple2(1, "a").instance().isNotNull();
	}

	@Test
	public function should_calling_instance_return_instance_of_ITuple2() : Void {
		tuple2(1, "a").instance().isType(ITuple2);
	}

	@Test
	public function should_calling_productArity_return_2() : Void {
		tuple2(1, "a").instance().productArity.areEqual(2);
	}

	@Test
	public function should_calling_productPrefix_return_Tuple2() : Void {
		tuple2(1, "a").instance().productPrefix.areEqual("Tuple2");
	}

	@Test
	public function should_calling_toString_return_Tuple1() : Void {
		tuple2(1, "a").instance().toString().areEqual("Tuple2(1,a)");
	}

	@Test
	public function should_calling_productElement_0_return_value() : Void {
		tuple2(1.1, "a").instance().productElement(0).areEqual(1.1);
	}

	@Test
	public function should_calling_productElement_1_return_value() : Void {
		tuple2(1.1, "a").instance().productElement(1).areEqual("a");
	}

	@Test
	public function should_calling__1_return_value() : Void {
		tuple2(1.1, "a").instance()._1.areEqual(1.1);
	}

	@Test
	public function should_calling__2_return_value() : Void {
		tuple2(1.1, "a").instance()._2.areEqual("a");
	}

	@Test
	public function should_calling_productElement_99_return_value() : Void {
		var called = try {
			tuple2(1.1, "a").instance().productElement(99);
		} catch(error : NoSuchElementError) {
			true;
		}

		Assert.isTrue(called);
	}
}
