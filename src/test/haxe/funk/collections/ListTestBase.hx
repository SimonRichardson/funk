package funk.collections;

import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;
import massive.munit.Assert;

using massive.munit.Assert;
using funk.collections.immutable.extensions.Lists;

class ListTestBase {

	public var actual : List<Int>;

	public var other : List<Int>;

	@Test
	public function should_be_non_empty() {
		actual.nonEmpty().isTrue();
	}

	@Test
	public function should_be_empty() {
		actual.isEmpty().isFalse();
	}

	@Test
	public function when_calling_toString__should_return_valid_string() {
		actual.toString().areEqual('List(1, 2, 3, 4)');
	}

	// Append

	@Test
	public function when_calling_append__should_not_be_null() : Void {
		actual.append(1).isNotNull();
	}

	@Test
	public function when_calling_append__should_be_size_5() : Void {
		actual.append(5).size().areEqual(5);
	}

	@Test
	public function when_calling_append__should_be_1_2_3_4_5() : Void {
		actual.append(5).toString().areEqual('List(1, 2, 3, 4, 5)');
	}

	@Test
	public function when_calling_appendAll__should_not_be_null() : Void {
		actual.appendAll(other).isNotNull();
	}

	@Test
	public function when_calling_appendAll__should_be_size_8() : Void {
		actual.appendAll(other).size().areEqual(8);
	}

	@Test
	public function when_calling_appendAll__should_be_1_2_3_4_5_6_7_8() : Void {
		actual.appendAll(other).toString().areEqual('List(1, 2, 3, 4, 5, 6, 7, 8)');
	}

	// Prepend

	@Test
	public function when_calling_prepend__should_not_be_null() : Void {
		actual.prepend(1).isNotNull();
	}

	@Test
	public function when_calling_prepend__should_be_size_5() : Void {
		actual.prepend(5).size().areEqual(5);
	}

	@Test
	public function when_calling_prepend__should_be_5_1_2_3_4() : Void {
		actual.prepend(5).toString().areEqual('List(5, 1, 2, 3, 4)');
	}

	@Test
	public function when_calling_prependAll__should_not_be_null() : Void {
		actual.prependAll(other).isNotNull();
	}

	@Test
	public function when_calling_prependAll__should_be_size_8() : Void {
		actual.prependAll(other).size().areEqual(8);
	}

	@Test
	public function when_calling_prependAll__should_be_8_7_6_5_1_2_3_4() : Void {
		actual.prependAll(other).toString().areEqual('List(8, 7, 6, 5, 1, 2, 3, 4)');
	}
}
