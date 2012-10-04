package funk.tuple;

import funk.errors.NoSuchElementError;
import funk.tuple.Tuple5;
import massive.munit.Assert;

using funk.tuple.Tuple5;
using massive.munit.Assert;

class Tuple5Test {

	@Test
	public function should_allow_creation_of_enum() : Void {
		tuple5(1, "a", 3.3, true, 5).isNotNull();
	}

	@Test
	public function should_calling__1_is_not_null() : Void {
		tuple5(1, "a", 3.3, true, 5)._1().isNotNull();
	}

	@Test
	public function should_calling__2_is_not_null() : Void {
		tuple5(1, "a", 3.3, true, 5)._2().isNotNull();
	}

	@Test
	public function should_calling__3_is_not_null() : Void {
		tuple5(1, "a", 3.3, true, 5)._3().isNotNull();
	}

	@Test
	public function should_calling__4_is_not_null() : Void {
		tuple5(1, "a", 3.3, true, 5)._4().isNotNull();
	}

	@Test
	public function should_calling__5_is_not_null() : Void {
		tuple5(1, "a", 3.3, true, 5)._5().isNotNull();
	}

	@Test
	public function should_calling__1_is_1() : Void {
		tuple5(1, "a", 3.3, true, 5)._1().areEqual(1);
	}

	@Test
	public function should_calling__2_is_a() : Void {
		tuple5(1, "a", 3.3, true, 5)._2().areEqual("a");
	}

	@Test
	public function should_calling__3_is_3_3() : Void {
		tuple5(1, "a", 3.3, true, 5)._3().areEqual(3.3);
	}

	@Test
	public function should_calling__4_is_true() : Void {
		tuple5(1, "a", 3.3, true, 5)._4().areEqual(true);
	}

	@Test
	public function should_calling__5_is_true() : Void {
		tuple5(1, "a", 3.3, true, 5)._5().areEqual(5);
	}

	@Test
	public function should_calling_instance_return_not_null() : Void {
		tuple5(1, "a", 3.3, true, 5).instance().isNotNull();
	}

	@Test
	public function should_calling_instance_return_instance_of_ITuple5() : Void {
		tuple5(1, "a", 3.3, true, 5).instance().isType(ITuple5);
	}

	@Test
	public function should_calling_productArity_return_5() : Void {
		tuple5(1, "a", 3.3, true, 5).instance().productArity.areEqual(5);
	}

	@Test
	public function should_calling_productPrefix_return_Tuple5() : Void {
		tuple5(1, "a", 3.3, true, 5).instance().productPrefix.areEqual("Tuple5");
	}

	@Test
	public function should_calling_toString_return_Tuple5() : Void {
		tuple5(1, "a", 3.3, true, 5).instance().toString().areEqual("Tuple5(1,a,3.3,true,5)");
	}

	@Test
	public function should_calling_productElement_0_return_value() : Void {
		tuple5(1.1, "a", 3.3, true, 5).instance().productElement(0).areEqual(1.1);
	}

	@Test
	public function should_calling_productElement_1_return_value() : Void {
		tuple5(1.1, "a", 3.3, true, 5).instance().productElement(1).areEqual("a");
	}

	@Test
	public function should_calling_productElement_2_return_value() : Void {
		tuple5(1.1, "a", 3.3, true, 5).instance().productElement(2).areEqual(3.3);
	}

	@Test
	public function should_calling_productElement_3_return_value() : Void {
		tuple5(1.1, "a", 3.3, true, 5).instance().productElement(3).areEqual(true);
	}

	@Test
	public function should_calling_productElement_4_return_value() : Void {
		tuple5(1.1, "a", 3.3, true, 5).instance().productElement(4).areEqual(5);
	}

	@Test
	public function should_calling__1_return_value() : Void {
		tuple5(1.1, "a", 3.3, true, 5).instance()._1.areEqual(1.1);
	}

	@Test
	public function should_calling__2_return_value() : Void {
		tuple5(1.1, "a", 3.3, true, 5).instance()._2.areEqual("a");
	}

	@Test
	public function should_calling__3_return_value() : Void {
		tuple5(1.1, "a", 3.3, true, 5).instance()._3.areEqual(3.3);
	}

	@Test
	public function should_calling__4_return_value() : Void {
		tuple5(1.1, "a", 3.3, true, 5).instance()._4.areEqual(true);
	}

	@Test
	public function should_calling__5_return_value() : Void {
		tuple5(1.1, "a", 3.3, true, 5).instance()._5.areEqual(5);
	}

	@Test
	public function should_calling_productElement_99_return_value() : Void {
		var called = try {
			tuple5(1.1, "a", 3.3, true, 5).instance().productElement(99);
		} catch(error : NoSuchElementError) {
			true;
		}

		Assert.isTrue(called);
	}
}
