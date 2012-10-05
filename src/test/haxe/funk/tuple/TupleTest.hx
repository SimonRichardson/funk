package funk.tuple;

import funk.errors.NoSuchElementError;
import funk.tuple.Tuple;
import massive.munit.Assert;

using funk.tuple.Tuple;
using massive.munit.Assert;

class TupleTest {

	// Tuple1

	@Test
	public function should_calling_toTuple1_should_return_valid_tuple() : Void {
		1.toTuple1().isNotNull();
	}

	@Test
	public function should_calling_toTuple1__1_is_not_null() : Void {
		1.toTuple1()._1.isNotNull();
	}

	@Test
	public function should_calling_toTuple1__1_is_equal_to_value() : Void {
		1.toTuple1()._1.areEqual(1);
	}

	// Tuple2

	@Test
	public function should_calling_toTuple2_should_return_valid_tuple() : Void {
		Tuples.toTuple2(1, 2).isNotNull();
	}

	@Test
	public function should_calling_toTuple2__1_is_not_null() : Void {
		Tuples.toTuple2(1, 2)._1.isNotNull();
	}

	@Test
	public function should_calling_toTuple2__1_is_equal_to_value() : Void {
		Tuples.toTuple2(1, 2)._1.areEqual(1);
	}

	@Test
	public function should_calling_toTuple2__2_is_not_null() : Void {
		Tuples.toTuple2(1, 2)._2.isNotNull();
	}

	@Test
	public function should_calling_toTuple2__2_is_equal_to_value() : Void {
		Tuples.toTuple2(1, 2)._2.areEqual(2);
	}

	// Tuple3

	@Test
	public function should_calling_toTuple3_should_return_valid_tuple() : Void {
		Tuples.toTuple3(1, 2, 3).isNotNull();
	}

	@Test
	public function should_calling_toTuple3__1_is_not_null() : Void {
		Tuples.toTuple3(1, 2, 3)._1.isNotNull();
	}

	@Test
	public function should_calling_toTuple3__1_is_equal_to_value() : Void {
		Tuples.toTuple3(1, 2, 3)._1.areEqual(1);
	}

	@Test
	public function should_calling_toTuple3__2_is_not_null() : Void {
		Tuples.toTuple3(1, 2, 3)._2.isNotNull();
	}

	@Test
	public function should_calling_toTuple3__2_is_equal_to_value() : Void {
		Tuples.toTuple3(1, 2, 3)._2.areEqual(2);
	}

	@Test
	public function should_calling_toTuple3__3_is_not_null() : Void {
		Tuples.toTuple3(1, 2, 3)._3.isNotNull();
	}

	@Test
	public function should_calling_toTuple3__3_is_equal_to_value() : Void {
		Tuples.toTuple3(1, 2, 3)._3.areEqual(3);
	}

	// Tuple4

	@Test
	public function should_calling_toTuple4_should_return_valid_tuple() : Void {
		Tuples.toTuple4(1, 2, 3, 4).isNotNull();
	}

	@Test
	public function should_calling_toTuple4__1_is_not_null() : Void {
		Tuples.toTuple4(1, 2, 3, 4)._1.isNotNull();
	}

	@Test
	public function should_calling_toTuple4__1_is_equal_to_value() : Void {
		Tuples.toTuple4(1, 2, 3, 4)._1.areEqual(1);
	}

	@Test
	public function should_calling_toTuple4__2_is_not_null() : Void {
		Tuples.toTuple4(1, 2, 3, 4)._2.isNotNull();
	}

	@Test
	public function should_calling_toTuple4__2_is_equal_to_value() : Void {
		Tuples.toTuple4(1, 2, 3, 4)._2.areEqual(2);
	}

	@Test
	public function should_calling_toTuple4__3_is_not_null() : Void {
		Tuples.toTuple4(1, 2, 3, 4)._3.isNotNull();
	}

	@Test
	public function should_calling_toTuple4__3_is_equal_to_value() : Void {
		Tuples.toTuple4(1, 2, 3, 4)._3.areEqual(3);
	}

	@Test
	public function should_calling_toTuple4__4_is_not_null() : Void {
		Tuples.toTuple4(1, 2, 3, 4)._4.isNotNull();
	}

	@Test
	public function should_calling_toTuple4__4_is_equal_to_value() : Void {
		Tuples.toTuple4(1, 2, 3, 4)._4.areEqual(4);
	}

	// Tuple5

	@Test
	public function should_calling_toTuple5_should_return_valid_tuple() : Void {
		Tuples.toTuple5(1, 2, 3, 4, 5).isNotNull();
	}

	@Test
	public function should_calling_toTuple5__1_is_not_null() : Void {
		Tuples.toTuple5(1, 2, 3, 4, 5)._1.isNotNull();
	}

	@Test
	public function should_calling_toTuple5__1_is_equal_to_value() : Void {
		Tuples.toTuple5(1, 2, 3, 4, 5)._1.areEqual(1);
	}

	@Test
	public function should_calling_toTuple5__2_is_not_null() : Void {
		Tuples.toTuple5(1, 2, 3, 4, 5)._2.isNotNull();
	}

	@Test
	public function should_calling_toTuple5__2_is_equal_to_value() : Void {
		Tuples.toTuple5(1, 2, 3, 4, 5)._2.areEqual(2);
	}

	@Test
	public function should_calling_toTuple5__3_is_not_null() : Void {
		Tuples.toTuple5(1, 2, 3, 4, 5)._3.isNotNull();
	}

	@Test
	public function should_calling_toTuple5__3_is_equal_to_value() : Void {
		Tuples.toTuple5(1, 2, 3, 4, 5)._3.areEqual(3);
	}

	@Test
	public function should_calling_toTuple5__4_is_not_null() : Void {
		Tuples.toTuple5(1, 2, 3, 4, 5)._4.isNotNull();
	}

	@Test
	public function should_calling_toTuple5__4_is_equal_to_value() : Void {
		Tuples.toTuple5(1, 2, 3, 4, 5)._4.areEqual(4);
	}

	@Test
	public function should_calling_toTuple5__5_is_not_null() : Void {
		Tuples.toTuple5(1, 2, 3, 4, 5)._5.isNotNull();
	}

	@Test
	public function should_calling_toTuple5__5_is_equal_to_value() : Void {
		Tuples.toTuple5(1, 2, 3, 4, 5)._5.areEqual(5);
	}
}
