package funk.tuple;

import funk.errors.NoSuchElementError;
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

	@Test
	public function should_calling_instance_return_not_null() : Void {
		tuple1(1).instance().isNotNull();
	}

	@Test
	public function should_calling_instance_return_instance_of_ITuple1() : Void {
		tuple1(1).instance().isType(ITuple1);
	}

	@Test
	public function should_calling_productArity_return_1() : Void {
		tuple1(1).instance().productArity.areEqual(1);
	}

	@Test
	public function should_calling_productPrefix_return_Tuple1() : Void {
		tuple1(1).instance().productPrefix.areEqual("Tuple1");
	}

	@Test
	public function should_calling_toString_return_Tuple1() : Void {
		tuple1(1).instance().toString().areEqual("Tuple1(1)");
	}

	@Test
	public function should_calling_productElement_0_return_value() : Void {
		tuple1(1.1).instance().productElement(0).areEqual(1.1);
	}

	@Test
	public function should_calling__1_return_value() : Void {
		tuple1(1.1).instance()._1.areEqual(1.1);
	}

	@Test
	public function should_calling_productElement_99_return_value() : Void {
		var called = try {
			tuple1(1.1).instance().productElement(99);
		} catch(error : NoSuchElementError) {
			true;
		}

		Assert.isTrue(called);
	}
}
