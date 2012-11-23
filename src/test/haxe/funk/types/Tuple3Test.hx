package funk.types;

import funk.types.Predicate2;
import funk.types.Tuple3;
import funk.types.Option;
import funk.types.extensions.Tuples3;
import funk.types.extensions.Options;
import massive.munit.Assert;

using funk.types.extensions.Tuples3;
using funk.types.extensions.Options;
using massive.munit.Assert;

class Tuple3Test {

	@Test
	public function when_calling_toString__should_return_valid_string() : Void {
		tuple3(1, 'a', 3).toString().areEqual('(1, a, 3)');
	}

	@Test
	public function should_allow_creation_of_enum() : Void {
		tuple3(1, 'a', 3).isNotNull();
	}

	@Test
	public function should_calling__1_is_not_null() : Void {
		tuple3(1, 'a', 3)._1().isNotNull();
	}

	@Test
	public function should_calling__1_is_1() : Void {
		tuple3(1, 'a', 3)._1().areEqual(1);
	}

	@Test
	public function should_calling__2_is_not_null() : Void {
		tuple3(1, 'a', 3)._2().isNotNull();
	}

	@Test
	public function should_calling__2_is_a() : Void {
		tuple3(1, 'a', 3)._2().areEqual('a');
	}

	@Test
	public function should_calling__3_is_not_null() : Void {
		tuple3(1, 'a', 3)._3().isNotNull();
	}

	@Test
	public function should_calling__3_is_3() : Void {
		tuple3(1, 'a', 3)._3().areEqual(3);
	}

	@Test
	public function when_calling_equals_with_same_values__should_be_true() : Void {
		tuple3(1, 'a', 3).equals(tuple3(1, 'a', 3)).isTrue();
	}

	@Test
	public function when_calling_equals_with_different_values__should_be_false() : Void {
		tuple3(1, 'a', 3).equals(tuple3(2, 'b', 3)).isFalse();
	}

	@Test
	public function when_calling_equals_with_optional_equality__should_be_false() : Void {
		tuple3(Some(1), Some('a'), Some(3)).equals(tuple3(Some(1), Some('a'), Some(3)), function(a, b) {
			return a.get() == b.get();
		}).isFalse();
	}

	@Test
	public function when_calling_equals_with_optional_second_equality__should_be_false() : Void {
		tuple3(Some(1), Some('a'), Some(3)).equals(tuple3(Some(1), Some('a'), Some(3)), null, function(a, b) {
			return a.get() == b.get();
		}).isFalse();
	}

	@Test
	public function when_calling_equals_with_optional_third_equality__should_be_false() : Void {
		tuple3(Some(1), Some('a'), Some(3)).equals(tuple3(Some(1), Some('a'), Some(3)), null, null, function(a, b) {
			return a.get() == b.get();
		}).isFalse();
	}

	@Test
	public function when_calling_equals_with_optional_all_equality__should_be_true() : Void {
		var equality : Predicate2<Option<Dynamic>, Option<Dynamic>> = function(a, b) : Bool {
			return a.get() == b.get();
		};

		tuple3(Some(1), Some('a'), Some(3)).equals(tuple3(Some(1), Some('a'), Some(3)), equality, equality, equality).isTrue();
	}
}
