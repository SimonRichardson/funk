package funk.tuple;

import funk.errors.NoSuchElementError;
import funk.tuple.Tuple4;
import massive.munit.Assert;

using funk.tuple.Tuple4;
using massive.munit.Assert;

class Tuple4Test {

	@Test
	public function should_allow_creation_of_enum() : Void {
		tuple4(1, "a", 3.3, true).isNotNull();
	}

	@Test
	public function should_calling__1_is_not_null() : Void {
		tuple4(1, "a", 3.3, true)._1().isNotNull();
	}

	@Test
	public function should_calling__2_is_not_null() : Void {
		tuple4(1, "a", 3.3, true)._2().isNotNull();
	}

	@Test
	public function should_calling__3_is_not_null() : Void {
		tuple4(1, "a", 3.3, true)._3().isNotNull();
	}

	@Test
	public function should_calling__4_is_not_null() : Void {
		tuple4(1, "a", 3.3, true)._4().isNotNull();
	}

	@Test
	public function should_calling__1_is_1() : Void {
		tuple4(1, "a", 3.3, true)._1().areEqual(1);
	}

	@Test
	public function should_calling__2_is_a() : Void {
		tuple4(1, "a", 3.3, true)._2().areEqual("a");
	}

	@Test
	public function should_calling__3_is_3_3() : Void {
		tuple4(1, "a", 3.3, true)._3().areEqual(3.3);
	}

	@Test
	public function should_calling__4_is_true() : Void {
		tuple4(1, "a", 3.3, true)._4().areEqual(true);
	}

	@Test
	public function should_calling_instance_return_not_null() : Void {
		tuple4(1, "a", 3.3, true).instance().isNotNull();
	}

	@Test
	public function should_calling_instance_return_instance_of_ITuple4() : Void {
		tuple4(1, "a", 3.3, true).instance().isType(ITuple4);
	}

	@Test
	public function should_calling_productArity_return_4() : Void {
		tuple4(1, "a", 3.3, true).instance().productArity.areEqual(4);
	}

	@Test
	public function should_calling_productPrefix_return_Tuple4() : Void {
		tuple4(1, "a", 3.3, true).instance().productPrefix.areEqual("Tuple4");
	}

	@Test
	public function should_calling_toString_return_Tuple4() : Void {
		tuple4(1, "a", 3.3, true).instance().toString().areEqual("Tuple4(1,a,3.3,true)");
	}

	@Test
	public function should_calling_productElement_0_return_value() : Void {
		tuple4(1.1, "a", 3.3, true).instance().productElement(0).areEqual(1.1);
	}

	@Test
	public function should_calling_productElement_1_return_value() : Void {
		tuple4(1.1, "a", 3.3, true).instance().productElement(1).areEqual("a");
	}

	@Test
	public function should_calling_productElement_2_return_value() : Void {
		tuple4(1.1, "a", 3.3, true).instance().productElement(2).areEqual(3.3);
	}

	@Test
	public function should_calling_productElement_3_return_value() : Void {
		tuple4(1.1, "a", 3.3, true).instance().productElement(3).areEqual(true);
	}

	@Test
	public function should_calling__1_return_value() : Void {
		tuple4(1.1, "a", 3.3, true).instance()._1.areEqual(1.1);
	}

	@Test
	public function should_calling__2_return_value() : Void {
		tuple4(1.1, "a", 3.3, true).instance()._2.areEqual("a");
	}

	@Test
	public function should_calling__3_return_value() : Void {
		tuple4(1.1, "a", 3.3, true).instance()._3.areEqual(3.3);
	}

	@Test
	public function should_calling__4_return_value() : Void {
		tuple4(1.1, "a", 3.3, true).instance()._4.areEqual(true);
	}

	@Test
	public function should_calling_productElement_99_return_value() : Void {
		var called = try {
			tuple4(1.1, "a", 3.3, true).instance().productElement(99);
		} catch(error : NoSuchElementError) {
			true;
		}

		Assert.isTrue(called);
	}
}
