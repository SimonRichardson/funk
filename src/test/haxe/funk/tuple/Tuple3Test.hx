package funk.tuple;

import funk.errors.NoSuchElementError;
import funk.tuple.Tuple3;
import massive.munit.Assert;

using funk.tuple.Tuple3;
using massive.munit.Assert;

class Tuple3Test {

	@Test
	public function should_allow_creation_of_enum() : Void {
		tuple3(1, "a", 3.3).isNotNull();
	}

	@Test
	public function should_calling__1_is_not_null() : Void {
		tuple3(1, "a", 3.3)._1().isNotNull();
	}

	@Test
	public function should_calling__2_is_not_null() : Void {
		tuple3(1, "a", 3.3)._2().isNotNull();
	}

	@Test
	public function should_calling__3_is_not_null() : Void {
		tuple3(1, "a", 3.3)._3().isNotNull();
	}

	@Test
	public function should_calling__1_is_1() : Void {
		tuple3(1, "a", 3.3)._1().areEqual(1);
	}

	@Test
	public function should_calling__2_is_a() : Void {
		tuple3(1, "a", 3.3)._2().areEqual("a");
	}

	@Test
	public function should_calling__3_is_3_3() : Void {
		tuple3(1, "a", 3.3)._3().areEqual(3.3);
	}

	@Test
	public function should_calling_instance_return_not_null() : Void {
		tuple3(1, "a", 3.3).instance().isNotNull();
	}

	@Test
	public function should_calling_instance_return_instance_of_ITuple3() : Void {
		tuple3(1, "a", 3.3).instance().isType(ITuple3);
	}

	@Test
	public function should_calling_productArity_return_3() : Void {
		tuple3(1, "a", 3.3).instance().productArity.areEqual(3);
	}

	@Test
	public function should_calling_productPrefix_return_Tuple3() : Void {
		tuple3(1, "a", 3.3).instance().productPrefix.areEqual("Tuple3");
	}

	@Test
	public function should_calling_toString_return_Tuple1() : Void {
		tuple3(1, "a", 3.3).instance().toString().areEqual("Tuple3(1,a,3.3)");
	}

	@Test
	public function should_calling_productElement_0_return_value() : Void {
		tuple3(1.1, "a", 3.3).instance().productElement(0).areEqual(1.1);
	}

	@Test
	public function should_calling_productElement_1_return_value() : Void {
		tuple3(1.1, "a", 3.3).instance().productElement(1).areEqual("a");
	}

	@Test
	public function should_calling_productElement_2_return_value() : Void {
		tuple3(1.1, "a", 3.3).instance().productElement(2).areEqual(3.3);
	}

	@Test
	public function should_calling__1_return_value() : Void {
		tuple3(1.1, "a", 3.3).instance()._1.areEqual(1.1);
	}

	@Test
	public function should_calling__2_return_value() : Void {
		tuple3(1.1, "a", 3.3).instance()._2.areEqual("a");
	}

	@Test
	public function should_calling__3_return_value() : Void {
		tuple3(1.1, "a", 3.3).instance()._3.areEqual(3.3);
	}

	@Test
	public function should_calling_productElement_99_return_value() : Void {
		var called = try {
			tuple3(1.1, "a", 3.3).instance().productElement(99);
		} catch(error : NoSuchElementError) {
			true;
		}

		Assert.isTrue(called);
	}
}
