package funk.types;

import funk.types.Predicate2;

using funk.types.Option;
using funk.types.Tuple4;
using massive.munit.Assert;

class Tuple4Test {

	@Test
	public function when_calling_join__should_return_valid_string() : Void {
		tuple4(1, 'a', 3, 'b').join().areEqual('1a3b');
	}

	@Test
	public function when_calling_toString__should_return_valid_string() : Void {
		tuple4(1, 'a', 3, 'b').toString().areEqual('(1, a, 3, b)');
	}

	@Test
	public function should_allow_creation_of_enum() : Void {
		tuple4(1, 'a', 3, 'b').isNotNull();
	}

	@Test
	public function should_calling__1_is_not_null() : Void {
		tuple4(1, 'a', 3, 'b')._1().isNotNull();
	}

	@Test
	public function should_calling__1_is_1() : Void {
		tuple4(1, 'a', 3, 'b')._1().areEqual(1);
	}

	@Test
	public function should_calling__2_is_not_null() : Void {
		tuple4(1, 'a', 3, 'b')._2().isNotNull();
	}

	@Test
	public function should_calling__2_is_a() : Void {
		tuple4(1, 'a', 3, 'b')._2().areEqual('a');
	}

	@Test
	public function should_calling__3_is_not_null() : Void {
		tuple4(1, 'a', 3, 'b')._3().isNotNull();
	}

	@Test
	public function should_calling__3_is_3() : Void {
		tuple4(1, 'a', 3, 'b')._3().areEqual(3);
	}

	@Test
	public function should_calling__4_is_not_null() : Void {
		tuple4(1, 'a', 3, 'b')._4().isNotNull();
	}

	@Test
	public function should_calling__4_is_b() : Void {
		tuple4(1, 'a', 3, 'b')._4().areEqual('b');
	}

	@Test
	public function when_calling_equals_with_same_values__should_be_true() : Void {
		tuple4(1, 'a', 3, 'b').equals(tuple4(1, 'a', 3, 'b')).isTrue();
	}

	@Test
	public function when_calling_equals_with_different_values__should_be_false() : Void {
		tuple4(1, 'a', 3, 'b').equals(tuple4(2, 'b', 3, 'd')).isFalse();
	}

	@Test
	public function when_calling_equals_with_optional_equality__should_be_false() : Void {
		tuple4(Some(1), Some('a'), Some(3), Some('b')).equals(tuple4(Some(1), Some('a'), Some(3), Some('b')), function(a, b) {
			return a.get() == b.get();
		}).isTrue();
	}

	@Test
	public function when_calling_equals_with_optional_second_equality__should_be_false() : Void {
		tuple4(Some(1), Some('a'), Some(3), Some('b')).equals(tuple4(Some(1), Some('a'), Some(3), Some('b')), null, function(a, b) {
			return a.get() == b.get();
		}).isTrue();
	}

	@Test
	public function when_calling_equals_with_optional_third_equality__should_be_false() : Void {
		tuple4(Some(1), Some('a'), Some(3), Some('b')).equals(tuple4(Some(1), Some('a'), Some(3), Some('b')), null, null, function(a, b) {
			return a.get() == b.get();
		}).isTrue();
	}

	@Test
	public function when_calling_equals_with_optional_fourth_equality__should_be_false() : Void {
		tuple4(Some(1), Some('a'), Some(3), Some('b')).equals(tuple4(Some(1), Some('a'), Some(3), Some('b')), null, null, null, function(a, b) {
			return a.get() == b.get();
		}).isTrue();
	}

	@Test
	public function when_calling_equals_with_optional_all_equality__should_be_true() : Void {
		var equality : Predicate2<Option<Dynamic>, Option<Dynamic>> = function(a, b) : Bool {
			return a.get() == b.get();
		};

		tuple4(Some(1), Some('a'), Some(3), Some('b')).equals(tuple4(Some(1), Some('a'), Some(3), Some('b')), equality, equality, equality, equality).isTrue();
	}
}
