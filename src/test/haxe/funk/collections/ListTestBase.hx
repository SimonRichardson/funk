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

	public var actualTotal : Int;

	public var other : List<Int>;

	public var otherTotal : Int;


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
		actual.toString().areEqual('List(1, 2, 3, 4, 5)');
	}

	// Contains

	@Test
	public function when_contains__should_contain_1() : Void {
		actual.contains(1).isTrue();
	}

	@Test
	public function when_contains__should_not_contain_99() : Void {
		actual.contains(99).isFalse();
	}

	@Test
	public function when_contains_overriding_equality__should_contain_99() : Void {
		actual.contains(99, function(a, b) {
			return true;
		}).isTrue();
	}

	// Count

	@Test
	public function should_call_count() : Void {
		var act = 0;
		actual.count(function(x) {
			act++;
			return true;
		});
		act.areEqual(actualTotal);
	}

	@Test
	public function should_count_be_same_as_expected() : Void {
		var act = actual.count(function(x) {
			return true;
		});
		act.areEqual(actualTotal);
	}

	@Test
	public function should_count_be_0() : Void {
		var act = actual.count(function(x) {
			return false;
		});
		act.areEqual(0);
	}

	@Test
	public function should_count_5_be_0() : Void {
		var act = actual.count(function(x) {
			return x % 2 == 0;
		});
		act.areEqual(Math.floor(actualTotal * 0.5));
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
		actual.tail().toString().areEqual('List(2, 3, 4, 5)');
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
		}).areEqual('Some(List(2, 3, 4, 5))');
	}

	// Reverse

	@Test
	public function when_calling_reverse__should_not_be_null() {
		actual.reverse().isNotNull();
	}

	@Test
	public function when_calling_reverse__should_be_5_4_3_2_1() {
		actual.reverse().toString().areEqual('List(5, 4, 3, 2, 1)');
	}

	// Append

	@Test
	public function when_calling_append__should_not_be_null() {
		actual.append(1).isNotNull();
	}

	@Test
	public function when_calling_append__should_be_size_5() {
		actual.append(6).size().areEqual(actualTotal + 1);
	}

	@Test
	public function when_calling_append__should_be_1_2_3_4_5() {
		actual.append(6).toString().areEqual('List(1, 2, 3, 4, 5, 6)');
	}

	@Test
	public function when_calling_appendAll__should_not_be_null() {
		actual.appendAll(other).isNotNull();
	}

	@Test
	public function when_calling_appendAll__should_be_correct_size() {
		actual.appendAll(other).size().areEqual(actualTotal + otherTotal);
	}

	@Test
	public function when_calling_appendAll__should_be_1_2_3_4_5_6_7_8_9() {
		actual.appendAll(other).toString().areEqual('List(1, 2, 3, 4, 5, 6, 7, 8, 9)');
	}

	// Prepend

	@Test
	public function when_calling_prepend__should_not_be_null() {
		actual.prepend(1).isNotNull();
	}

	@Test
	public function when_calling_prepend__should_be_correct_size() {
		actual.prepend(6).size().areEqual(actualTotal + 1);
	}

	@Test
	public function when_calling_prepend__should_be_6_1_2_3_4_5() {
		actual.prepend(6).toString().areEqual('List(6, 1, 2, 3, 4, 5)');
	}

	@Test
	public function when_calling_prependAll__should_not_be_null() {
		actual.prependAll(other).isNotNull();
	}

	@Test
	public function when_calling_prependAll__should_be_correct_size() {
		actual.prependAll(other).size().areEqual(actualTotal + otherTotal);
	}

	@Test
	public function when_calling_prependAll__should_be_9_8_7_6_1_2_3_4_5() {
		actual.prependAll(other).toString().areEqual('List(9, 8, 7, 6, 1, 2, 3, 4, 5)');
	}

	// Indices

	@Test
	public function when_indices__should_not_be_null() : Void {
		actual.indices().isNotNull();
	}

	@Test
	public function when_indices__should_be_equal_0_1_2_3_4() : Void {
		actual.indices().toString().areEqual('List(0, 1, 2, 3, 4)');
	}

	// Drop

	@Test
	public function when_drop_0__return_same_list() : Void {
		actual.drop(0).areEqual(actual);
	}

	@Test
	public function when_drop_2__return_List_3_4_5() : Void {
		actual.drop(2).toString().areEqual('List(3, 4, 5)');
	}

	@Test
	public function when_drop_2__return_size_3() : Void {
		actual.drop(2).size().areEqual(3);
	}

	@Test
	public function when_drop_4__return_size_1() : Void {
		actual.drop(4).size().areEqual(1);
	}

	@Test
	public function when_drop_5__return_size_0() : Void {
		actual.drop(5).size().areEqual(0);
	}

	@Test
	public function when_drop_2__return_get_0_is_3() : Void {
		actual.drop(2).get(0).areEqual(Some(3));
	}

	@Test
	public function when_drop_2__return_get_1_is_4() : Void {
		actual.drop(2).get(1).areEqual(Some(4));
	}

	@Test
	public function when_drop_2_then_1__return_get_0_is_4() : Void {
		actual.drop(2).drop(1).get(0).areEqual(Some(4));
	}

	@Test
	public function when_drop_on_list__throw_argument_when_passing_minus_to_drop() : Void {
		var called = try {
			actual.drop(-1);
			false;
		} catch(error : Dynamic) {
			true;
		}
		called.isTrue();
	}

	// Drop Right

	@Test
	public function when_dropRight_0_on_list__return_same_list() : Void {
		actual.dropRight(0).areEqual(actual);
	}

	@Test
	public function when_dropRight_1_on_list__return_and_get_0_equals_1() : Void {
		actual.dropRight(1).get(0).areEqual(Some(1));
	}

	@Test
	public function when_dropRight_2_on_list__returns_1_2_3() : Void {
		actual.dropRight(2).toString().areEqual('List(1, 2, 3)');
	}

	@Test
	public function when_dropRight_2_on_list__return_and_get_2_equals_3() : Void {
		actual.dropRight(2).get(2).areEqual(Some(3));
	}

	@Test
	public function when_dropRight_5__return_size_0() : Void {
		actual.dropRight(5).size().areEqual(0);
	}

	@Test
	public function when_dropRight_on_list__throw_argument_when_passing_minus_to_dropRight() : Void {
		var called = try {
			actual.dropRight(-1);
			false;
		} catch(error : Dynamic) {
			true;
		}
		called.isTrue();
	}

	// Drop While

	@Test
	public function when_dropWhile__return_not_null() : Void {
		actual.dropWhile(function(x) {
			return x < 2;
		}).isNotNull();
	}

	@Test
	public function when_dropWhile__return_is_type_of_list() : Void {
		actual.dropWhile(function(x) {
			return x < 2;
		}).toString().areEqual('List(2, 3, 4, 5)');
	}

	@Test
	public function when_dropWhile__return_size_is_4() : Void {
		actual.dropWhile(function(x) {
			return x < 2;
		}).size().areEqual(4);
	}

	@Test
	public function when_dropWhile__return_get_2_equals_4() : Void {
		actual.dropWhile(function(x) {
			return x < 2;
		}).get(2).areEqual(Some(4));
	}

	@Test
	public function when_dropWhile__return_size_equals_0() : Void {
		actual.dropWhile(function(x) {
			return true;
		}).size().areEqual(0);
	}
}
