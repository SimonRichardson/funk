package funk.collections;

import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;
import funk.types.Option;
import funk.types.Tuple2;
import funk.types.extensions.Options;
import funk.types.extensions.Tuples2;
import massive.munit.Assert;

using massive.munit.Assert;
using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Options;
using funk.types.extensions.Tuples2;

class ListTestBase {

	public var alpha : List<String>;

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

	// Exists

	@Test
	public function when_exists__should_return_true_when_calling_exists() : Void {
		actual.exists(function(x) {
			return x == 2;
		}).isTrue();
	}

	@Test
	public function when_exists_all_false__should_return_false_when_calling_exists() : Void {
		actual.exists(function(x) {
			return false;
		}).isFalse();
	}

	@Test
	public function when_exists_all_true__should_return_true_when_calling_exists() : Void {
		actual.exists(function(x) {
			return true;
		}).isTrue();
	}

	// Flat Map

	@Test
	public function when_flatMap__should_return_a_list_containing_concat_lists() : Void {
		var result = actual.flatMap(function(x) {
			return other;
		});

		result.toString().areEqual('List(6, 7, 8, 9, 6, 7, 8, 9, 6, 7, 8, 9, 6, 7, 8, 9, 6, 7, 8, 9)');
	}

	// Filter

	@Test
	public function when_filter__should_return_list() : Void {
		actual.filter(function(x) {
			return x == 1;
		}).toString().areEqual('List(1)');
	}

	@Test
	public function when_filter__should_return_list_of_size_1() : Void {
		actual.filter(function(x) {
			return x == 1;
		}).size().areEqual(1);
	}

	@Test
	public function when_filter__should_return_even_list_of_size_2() : Void {
		actual.filter(function(x) {
			return x % 2 == 0;
		}).size().areEqual(2);
	}

	@Test
	public function when_filter__should_return_even_list_toString() : Void {
		actual.filter(function(x) {
			return x % 2 == 0;
		}).toString().areEqual('List(2, 4)');
	}

	@Test
	public function when_filter_all__should_return_size_of_5() : Void {
		actual.filter(function(x) {
			return true;
		}).size().areEqual(actualTotal);
	}

	@Test
	public function when_filter_all__should_return_toString() : Void {
		actual.filter(function(x) {
			return true;
		}).toString().areEqual('List(1, 2, 3, 4, 5)');
	}

	@Test
	public function when_filter_all_false__should_return_size_of_0() : Void {
		actual.filter(function(x) {
			return false;
		}).size().areEqual(0);
	}

	// Filter Not

	@Test
	public function when_filterNot__should_return_list() : Void {
		actual.filterNot(function(x) {
			return x == 1;
		}).toString().areEqual('List(2, 3, 4, 5)');
	}

	@Test
	public function when_filterNot__should_return_list_of_size_1() : Void {
		actual.filterNot(function(x) {
			return x == 1;
		}).size().areEqual(4);
	}

	@Test
	public function when_filterNot_should_return_even_list_of_size_2() : Void {
		actual.filterNot(function(x) {
			return x % 2 == 0;
		}).size().areEqual(3);
	}

	@Test
	public function when_filterNot__should_return_even_list_toString() : Void {
		actual.filterNot(function(x) {
			return x % 2 == 0;
		}).toString().areEqual('List(1, 3, 5)');
	}

	@Test
	public function when_filterNot_all__should_return_size_of_5() : Void {
		actual.filterNot(function(x) {
			return false;
		}).size().areEqual(actualTotal);
	}

	@Test
	public function when_filterNot_all__should_return_toString() : Void {
		actual.filterNot(function(x) {
			return false;
		}).toString().areEqual('List(1, 2, 3, 4, 5)');
	}

	@Test
	public function when_filterNot_all_true__should_return_size_of_0() : Void {
		actual.filterNot(function(x) {
			return true;
		}).size().areEqual(0);
	}

	// Find

	@Test
	public function when_find__should_return_Option() : Void {
		actual.find(function(x) {
			return x == 2;
		}).areEqual(Some(2));
	}

	@Test
	public function when_find__should_return_Some() : Void {
		actual.find(function(x) {
			return x == 2;
		}).isDefined().isTrue();
	}

	@Test
	public function when_find__should_call_find() : Void {
		var called = false;
		actual.find(function(x) {
			called = true;
			return x == 2;
		});
		called.isTrue();
	}

	@Test
	public function when_find_all_false__should_return_none() : Void {
		actual.find(function(x) {
			return false;
		}).areEqual(None);
	}

	// Fold Left

	@Test
	public function when_foldLeft__should_foldLeft_should_return_10() : Void {
		actual.foldLeft(0, function (a, b) {
			return a + b;
		}).areEqual(15);
	}

	@Test
	public function when_foldLeft__should_foldLeft_should_return_11() : Void {
		actual.foldLeft(1, function (a, b) {
			return a + b;
		}).areEqual(16);
	}

	@Test
	public function when_foldLeft__should_call_foldLeft() : Void {
		actual.foldLeft(0, function(x, y) {
			return 0;
		}).areEqual(0);
	}

	@Test
	public function when_foldLeft__should_foldLeft_should_return_abcde() : Void {
		alpha.foldLeft('', function (a, b) {
			return a + b;
		}).areEqual('abcde');
	}

	// Fold Right

	@Test
	public function when_foldRight__should_foldRight_should_return_10() : Void {
		actual.foldRight(0, function (a, b) {
			return a + b;
		}).areEqual(15);
	}

	@Test
	public function when_foldRight__should_foldRight_should_return_11() : Void {
		actual.foldRight(1, function (a, b) {
			return a + b;
		}).areEqual(16);
	}

	@Test
	public function when_foldRight__should_call_foldRight() : Void {
		actual.foldRight(0, function(x, y) {
			return 0;
		}).areEqual(0);
	}

	@Test
	public function when_foldRight__should_foldRight_should_return_abcde() : Void {
		alpha.foldRight('', function (a, b) {
			return a + b;
		}).areEqual('edcba');
	}

	// For All

	@Test
	public function when_forall__should_return_true() : Void {
		actual.forall(function(value) {
			return true;
		}).isTrue();
	}

	@Test
	public function when_forall__should_return_false_if_value_is_less_than_2() : Void {
		actual.forall(function(value) {
			return value == 2;
		}).isFalse();
	}

	// For Each

	@Test
	public function when_foreach__should_run_function() : Void {
		var called = false;
		actual.foreach(function(value : Int) : Void {
			called = true;
		});
		called.isTrue();
	}

	@Test
	public function when_foreach__should_run_function_correct_num_times() : Void {
		var act = 0;
		actual.foreach(function(value) {
			act++;
		});
		act.areEqual(actualTotal);
	}

	// Map

	@Test
	public function when_map__should_return_list() : Void {
		actual.map(function(value) {
			return value + 1.1;
		}).toString().areEqual('List(2.1, 3.1, 4.1, 5.1, 6.1)');
	}

	@Test
	public function when_map__should_return_list_of_size() : Void {
		actual.map(function(value) {
			return value + 1.1;
		}).size().areEqual(actualTotal);
	}

	@Test
	public function when_map__should_calling_get_0_return_2() : Void {
		actual.map(function(value) {
			return value + 1.1;
		}).get(0).areEqual(Some(2.1));
	}

	@Test
	public function when_map__should_calling_get_1_return_3() : Void {
		actual.map(function(value) {
			return value + 1.1;
		}).get(1).areEqual(Some(3.1));
	}

	@Test
	public function when_map__should_calling_get_0_return_Hello1() : Void {
		actual.map(function(value : Int) : String {
			return "Hello" + value;
		}).get(0).areEqual(Some("Hello1"));
	}

	@Test
	public function when_map__should_calling_get_0_return_same_instance_as_past_in() : Void {
		var instance = {};
		actual.map(function(value) {
			return instance;
		}).get(0).areEqual(Some(instance));
	}

	// Init

	@Test
	public function when_init__should_not_be_null() : Void {
		actual.init().isNotNull();
	}

	@Test
	public function when_init__should_size_should_be_4() : Void {
		actual.init().size().areEqual(4);
	}

	@Test
	public function when_init__should_be_equal_4() : Void {
		actual.init().toString().areEqual('List(1, 2, 3, 4)');
	}

	// Last

	@Test
	public function when_last__should_not_be_null() : Void {
		actual.last().isNotNull();
	}

	@Test
	public function when_last__should_be_equal_to_Option() : Void {
		actual.last().areEqual(Some(5));
	}

	@Test
	public function when_last__should_be_equal_to_Some() : Void {
		actual.last().isDefined().isTrue();
	}

	@Test
	public function when_last__should_be_equal_to_Some_value_of_5() : Void {
		actual.last().get().areEqual(5);
	}

	// Zip With Index

	@Test
	public function when_zipWithIndex__should_not_be_null() : Void {
		actual.zipWithIndex().isNotNull();
	}

	@Test
	public function when_zipWithIndex__should_be_equal_to_nil() : Void {
		actual.zipWithIndex().toString(function (tuple) {
			return tuple.toString();
		}).areEqual('List((1, 0), (2, 1), (3, 2), (4, 3), (5, 4))');
	}

	// Has Defined Size

	@Test
	public function should_have_a_defined_size():Void {
		actual.hasDefinedSize().isTrue();
	}
}
