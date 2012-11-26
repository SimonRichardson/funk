package funk.collections;

import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;
import funk.types.Option;
import funk.types.extensions.Options;
import massive.munit.Assert;

using massive.munit.Assert;
using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Options;

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

	// Head

	@Test
	public function when_head__should_not_be_null() : Void {
		actual.head().isNotNull();
	}

	@Test
	public function when_head__should_be_1() : Void {
		actual.head().areEqual(1);
	}

	@Test
	public function when_headOption__should_be_Option() : Void {
		actual.headOption().areEqual(Some(1));
	}

	@Test
	public function when_headOption__should_be_Some() : Void {
		actual.headOption().isDefined().isTrue();
	}

	@Test
	public function when_headOption__should_be_Some_of_value_1() : Void {
		actual.headOption().get().areEqual(1);
	}

	// Tail

	@Test
	public function when_tail__should_not_be_null() : Void {
		actual.tail().isNotNull();
	}

	@Test
	public function when_tail__should_be_2_3_4() : Void {
		actual.tail().toString().areEqual('List(2, 3, 4)');
	}

	@Test
	public function when_tailOption__should_be_Option() : Void {
		actual.tailOption().areEqual(Some(actual.tail()));
	}

	@Test
	public function when_tailOption__should_be_Some() : Void {
		actual.tailOption().isDefined().isTrue();
	}

	@Test
	public function when_tailOption__should_be_Some_value_of_2_3_4() : Void {
		actual.tailOption().areEqual(Some(actual.tail()));
	}

	@Test
	public function when_tailOption__should_be_Some_2_3_4() : Void {
		actual.tailOption().toString(function(value : List<Int>) {
			return value.toString();
		}).areEqual('Some(List(2, 3, 4))');
	}

	// Reverse

	@Test
	public function when_calling_reverse__should_not_be_null() {
		actual.reverse().isNotNull();
	}

	@Test
	public function when_calling_reverse__should_be_4_3_2_1() {
		actual.reverse().toString().areEqual('List(4, 3, 2, 1)');
	}

	// Append

	@Test
	public function when_calling_append__should_not_be_null() {
		actual.append(1).isNotNull();
	}

	@Test
	public function when_calling_append__should_be_size_5() {
		actual.append(5).size().areEqual(5);
	}

	@Test
	public function when_calling_append__should_be_1_2_3_4_5() {
		actual.append(5).toString().areEqual('List(1, 2, 3, 4, 5)');
	}

	@Test
	public function when_calling_appendAll__should_not_be_null() {
		actual.appendAll(other).isNotNull();
	}

	@Test
	public function when_calling_appendAll__should_be_size_8() {
		actual.appendAll(other).size().areEqual(8);
	}

	@Test
	public function when_calling_appendAll__should_be_1_2_3_4_5_6_7_8() {
		actual.appendAll(other).toString().areEqual('List(1, 2, 3, 4, 5, 6, 7, 8)');
	}

	// Prepend

	@Test
	public function when_calling_prepend__should_not_be_null() {
		actual.prepend(1).isNotNull();
	}

	@Test
	public function when_calling_prepend__should_be_size_5() {
		actual.prepend(5).size().areEqual(5);
	}

	@Test
	public function when_calling_prepend__should_be_5_1_2_3_4() {
		actual.prepend(5).toString().areEqual('List(5, 1, 2, 3, 4)');
	}

	@Test
	public function when_calling_prependAll__should_not_be_null() {
		actual.prependAll(other).isNotNull();
	}

	@Test
	public function when_calling_prependAll__should_be_size_8() {
		actual.prependAll(other).size().areEqual(8);
	}

	@Test
	public function when_calling_prependAll__should_be_8_7_6_5_1_2_3_4() {
		actual.prependAll(other).toString().areEqual('List(8, 7, 6, 5, 1, 2, 3, 4)');
	}
}
