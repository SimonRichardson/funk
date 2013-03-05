package funk.types;

using funk.types.Option;
using funk.types.Tuple1;
using massive.munit.Assert;

class Tuple1Test {

	@Test
	public function when_calling_join__should_return_valid_string() : Void {
		tuple1(1).join().areEqual('1');
	}

	@Test
	public function when_calling_toString__should_return_valid_string() : Void {
		tuple1(1).toString().areEqual('(1)');
	}

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
	public function when_calling_equals_with_same_values__should_be_true() : Void {
		tuple1(1).equals(tuple1(1)).isTrue();
	}

	@Test
	public function when_calling_equals_with_different_values__should_be_false() : Void {
		tuple1(1).equals(tuple1(2)).isFalse();
	}

	@Test
	public function when_calling_equals_with_optional_equality__should_be_true() : Void {
		tuple1(Some(1)).equals(tuple1(Some(1)), function(a, b) {
			return a.get() == b.get();
		}).isTrue();
	}
}
