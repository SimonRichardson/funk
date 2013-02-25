package funk.types;

import funk.types.Tuple2;
import haxe.ds.Option;
import funk.types.extensions.Tuples2;
import funk.types.extensions.Options;
import massive.munit.Assert;

using funk.types.extensions.Tuples2;
using funk.types.extensions.Options;
using massive.munit.Assert;

class Tuple2Test {

	@Test
	public function when_calling_join__should_return_valid_string() : Void {
		tuple2(1, 'a').join().areEqual('1a');
	}

	@Test
	public function when_calling_toString__should_return_valid_string() : Void {
		tuple2(1, 'a').toString().areEqual('(1, a)');
	}

	@Test
	public function should_allow_creation_of_enum() : Void {
		tuple2(1, 'a').isNotNull();
	}

	@Test
	public function should_calling__1_is_not_null() : Void {
		tuple2(1, 'a')._1().isNotNull();
	}

	@Test
	public function should_calling__1_is_1() : Void {
		tuple2(1, 'a')._1().areEqual(1);
	}

	@Test
	public function should_calling__2_is_not_null() : Void {
		tuple2(1, 'a')._2().isNotNull();
	}

	@Test
	public function should_calling__2_is_a() : Void {
		tuple2(1, 'a')._2().areEqual('a');
	}

	@Test
	public function when_calling_swap__should_1_be_a() : Void {
		tuple2(1, 'a').swap()._1().areEqual('a');
	}

	@Test
	public function when_calling_swap__should_2_be_1() : Void {
		tuple2(1, 'a').swap()._2().areEqual(1);
	}

	@Test
	public function when_calling_equals_with_same_values__should_be_true() : Void {
		tuple2(1, 'a').equals(tuple2(1, 'a')).isTrue();
	}

	@Test
	public function when_calling_equals_with_different_values__should_be_false() : Void {
		tuple2(1, 'a').equals(tuple2(2, 'b')).isFalse();
	}

	@Test
	public function when_calling_equals_with_optional_equality__should_be_false() : Void {
		tuple2(Some(1), Some('a')).equals(tuple2(Some(1), Some('a')), function(a, b) {
			return a.get() == b.get();
		}).isTrue();
	}

	@Test
	public function when_calling_equals_with_optional_second_equality__should_be_false() : Void {
		tuple2(Some(1), Some('a')).equals(tuple2(Some(1), Some('a')), null, function(a, b) {
			return a.get() == b.get();
		}).isTrue();
	}

	@Test
	public function when_calling_equals_with_optional_all_equality__should_be_true() : Void {
		tuple2(Some(1), Some('a')).equals(tuple2(Some(1), Some('a')), function(a, b) {
			return a.get() == b.get();
		}, function(a, b) {
			return a.get() == b.get();
		}).isTrue();
	}
}
