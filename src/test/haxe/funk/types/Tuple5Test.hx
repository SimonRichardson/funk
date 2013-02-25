package funk.types;

import funk.types.Predicate2;
import funk.types.Tuple5;
import haxe.ds.Option;
import funk.types.extensions.Tuples5;
import funk.types.extensions.Options;
import massive.munit.Assert;

using funk.types.extensions.Tuples5;
using funk.types.extensions.Options;
using massive.munit.Assert;

class Tuple5Test {

	@Test
	public function when_calling_join__should_return_valid_string() : Void {
		tuple5(1, 'a', 3, 'b', 5).join().areEqual('1a3b5');
	}

	@Test
	public function when_calling_toString__should_return_valid_string() : Void {
		tuple5(1, 'a', 3, 'b', 5).toString().areEqual('(1, a, 3, b, 5)');
	}

	@Test
	public function should_allow_creation_of_enum() : Void {
		tuple5(1, 'a', 3, 'b', 5).isNotNull();
	}

	@Test
	public function should_calling__1_is_not_null() : Void {
		tuple5(1, 'a', 3, 'b', 5)._1().isNotNull();
	}

	@Test
	public function should_calling__1_is_1() : Void {
		tuple5(1, 'a', 3, 'b', 5)._1().areEqual(1);
	}

	@Test
	public function should_calling__2_is_not_null() : Void {
		tuple5(1, 'a', 3, 'b', 5)._2().isNotNull();
	}

	@Test
	public function should_calling__2_is_a() : Void {
		tuple5(1, 'a', 3, 'b', 5)._2().areEqual('a');
	}

	@Test
	public function should_calling__3_is_not_null() : Void {
		tuple5(1, 'a', 3, 'b', 5)._3().isNotNull();
	}

	@Test
	public function should_calling__3_is_3() : Void {
		tuple5(1, 'a', 3, 'b', 5)._3().areEqual(3);
	}

	@Test
	public function should_calling__4_is_not_null() : Void {
		tuple5(1, 'a', 3, 'b', 5)._4().isNotNull();
	}

	@Test
	public function should_calling__4_is_b() : Void {
		tuple5(1, 'a', 3, 'b', 5)._4().areEqual('b');
	}

	@Test
	public function should_calling__5_is_not_null() : Void {
		tuple5(1, 'a', 3, 'b', 5)._5().isNotNull();
	}

	@Test
	public function should_calling__5_is_5() : Void {
		tuple5(1, 'a', 3, 'b', 5)._5().areEqual(5);
	}

	@Test
	public function when_calling_equals_with_same_values__should_be_true() : Void {
		tuple5(1, 'a', 3, 'b', 5).equals(tuple5(1, 'a', 3, 'b', 5)).isTrue();
	}

	@Test
	public function when_calling_equals_with_different_values__should_be_false() : Void {
		tuple5(1, 'a', 3, 'b', 5).equals(tuple5(2, 'b', 3, 'd', 6)).isFalse();
	}

	@Test
	public function when_calling_equals_with_optional_equality__should_be_false() : Void {
		tuple5(Some(1), Some('a'), Some(3), Some('b'), Some(5)).equals(tuple5(Some(1), Some('a'), Some(3), Some('b'), Some(5)), function(a, b) {
			return a.get() == b.get();
		}).isTrue();
	}

	@Test
	public function when_calling_equals_with_optional_second_equality__should_be_false() : Void {
		tuple5(Some(1), Some('a'), Some(3), Some('b'), Some(5)).equals(tuple5(Some(1), Some('a'), Some(3), Some('b'), Some(5)), null, function(a, b) {
			return a.get() == b.get();
		}).isTrue();
	}

	@Test
	public function when_calling_equals_with_optional_third_equality__should_be_false() : Void {
		tuple5(Some(1), Some('a'), Some(3), Some('b'), Some(5)).equals(tuple5(Some(1), Some('a'), Some(3), Some('b'), Some(5)), null, null, function(a, b) {
			return a.get() == b.get();
		}).isTrue();
	}

	@Test
	public function when_calling_equals_with_optional_fourth_equality__should_be_false() : Void {
		tuple5(Some(1), Some('a'), Some(3), Some('b'), Some(5)).equals(tuple5(Some(1), Some('a'), Some(3), Some('b'), Some(5)), null, null, null, function(a, b) {
			return a.get() == b.get();
		}).isTrue();
	}

	@Test
	public function when_calling_equals_with_optional_fifth_equality__should_be_false() : Void {
		tuple5(Some(1), Some('a'), Some(3), Some('b'), Some(5)).equals(tuple5(Some(1), Some('a'), Some(3), Some('b'), Some(5)), null, null, null, null, function(a, b) {
			return a.get() == b.get();
		}).isTrue();
	}

	@Test
	public function when_calling_equals_with_optional_all_equality__should_be_true() : Void {
		var equality : Predicate2<Option<Dynamic>, Option<Dynamic>> = function(a, b) : Bool {
			return a.get() == b.get();
		};

		tuple5(Some(1), Some('a'), Some(3), Some('b'), Some(5)).equals(tuple5(Some(1), Some('a'), Some(3), Some('b'), Some(5)), equality, equality, equality, equality, equality).isTrue();
	}
}
