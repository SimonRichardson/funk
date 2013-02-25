package funk.collections;

import funk.collections.Collection;
import funk.collections.extensions.Collections;
import funk.types.Option;
import funk.types.Tuple2;
import funk.types.extensions.Options;
import funk.types.extensions.Tuples2;
import massive.munit.Assert;
import unit.Asserts;

using massive.munit.Assert;
using funk.collections.extensions.Collections;
using funk.types.extensions.Options;
using funk.types.extensions.Tuples2;
using unit.Asserts;

class CollectionsTestBase {

	public var alpha : Collection<String>;

	public var actual : Collection<Int>;

	public var actualTotal : Int;

	public var complex : Collection<Collection<Int>>;

	public var other : Collection<Int>;

	public var otherTotal : Int;

	public var empty : Collection<Int>;

	public var emptyTotal : Int;

	public var name : String;

	public var emptyName : String;

	@Test
	public function should_be_non_empty() {
		actual.nonEmpty().isTrue();
	}

	@Test
	public function should_not_be_empty() {
		actual.isEmpty().isFalse();
	}

	@Test
	public function when_calling_toString__should_return_valid_string() {
		actual.toString().areEqual('$name(1, 2, 3, 4, 5)');
	}

	@Test
	public function when_calling_toString_on_a_complex_list__should_return_valid_string() {
		complex.toString(function (x) {
			return x.toString();
		}).areEqual('$name($name(1, 2, 3), $name(4, 5), $name(6), $name(7, 8, 9))');
	}

	@Test
	public function should_be_empty() {
		empty.isEmpty().isTrue();
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
		actual.tail().toString().areEqual('$name(2, 3, 4, 5)');
	}

	@Test
	public function when_tailOption__should_be_Option() : Void {
		actual.tailOption().get().areIterablesEqual(actual.tail());
	}

	@Test
	public function when_tailOption__should_be_Some() : Void {
		actual.tailOption().isDefined().isTrue();
	}

	@Test
	public function when_tailOption__should_be_Some_value_of_2_3_4() : Void {
		actual.tailOption().get().areIterablesEqual(actual.tail());
	}

	@Test
	public function when_tailOption__should_be_Some_2_3_4() : Void {
		actual.tailOption().toString(function(value) {
			return value.toString();
		}).areEqual('Some($name(2, 3, 4, 5))');
	}

	// Reverse

	@Test
	public function when_calling_reverse__should_not_be_null() {
		actual.reverse().isNotNull();
	}

	@Test
	public function when_calling_reverse__should_be_5_4_3_2_1() {
		actual.reverse().toString().areEqual('$name(5, 4, 3, 2, 1)');
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
		actual.append(6).toString().areEqual('$name(1, 2, 3, 4, 5, 6)');
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
		actual.appendAll(other).toString().areEqual('$name(1, 2, 3, 4, 5, 6, 7, 8, 9)');
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
		actual.prepend(6).toString().areEqual('$name(6, 1, 2, 3, 4, 5)');
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
		actual.prependAll(other).toString().areEqual('$name(9, 8, 7, 6, 1, 2, 3, 4, 5)');
	}

	// Indices

	@Test
	public function when_indices__should_not_be_null() : Void {
		actual.indices().isNotNull();
	}

	@Test
	public function when_indices__should_be_equal_0_1_2_3_4() : Void {
		actual.indices().toString().areEqual('$name(0, 1, 2, 3, 4)');
	}

	// Drop

	@Test
	public function when_dropLeft_0__return_same_list() : Void {
		actual.dropLeft(0).areEqual(actual);
	}

	@Test
	public function when_dropLeft_2__return_List_3_4_5() : Void {
		actual.dropLeft(2).toString().areEqual('$name(3, 4, 5)');
	}

	@Test
	public function when_dropLeft_2__return_size_3() : Void {
		actual.dropLeft(2).size().areEqual(3);
	}

	@Test
	public function when_dropLeft_4__return_size_1() : Void {
		actual.dropLeft(4).size().areEqual(1);
	}

	@Test
	public function when_dropLeft_5__return_size_0() : Void {
		actual.dropLeft(5).size().areEqual(0);
	}

	@Test
	public function when_dropLeft_2__return_get_0_is_3() : Void {
		actual.dropLeft(2).get(0).areEqual(Some(3));
	}

	@Test
	public function when_dropLeft_2__return_get_1_is_4() : Void {
		actual.dropLeft(2).get(1).areEqual(Some(4));
	}

	@Test
	public function when_dropLeft_2_then_1__return_get_0_is_4() : Void {
		actual.dropLeft(2).dropLeft(1).get(0).areEqual(Some(4));
	}

	@Test
	public function when_dropLeft_on_list__throw_argument_when_passing_minus_to_drop() : Void {
		var called = try {
			actual.dropLeft(-1);
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
		actual.dropRight(2).toString().areEqual('$name(1, 2, 3)');
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
		}).toString().areEqual('$name(2, 3, 4, 5)');
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

		result.toString().areEqual('$name(6, 7, 8, 9, 6, 7, 8, 9, 6, 7, 8, 9, 6, 7, 8, 9, 6, 7, 8, 9)');
	}

	// Flatten

	@Test
	public function when_flatten__should_flatten_list() : Void {
		actual.flatten().areIterablesEqual(actual);
	}

	@Test
	public function when_flatten__should_flatten_sublists() : Void {
		complex.flatten().toString().areEqual('$name(1, 2, 3, 4, 5, 6, 7, 8, 9)');
	}

	// Filter

	@Test
	public function when_filter__should_return_list() : Void {
		actual.filter(function(x) {
			return x == 1;
		}).toString().areEqual('$name(1)');
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
		}).toString().areEqual('$name(2, 4)');
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
		}).toString().areEqual('$name(1, 2, 3, 4, 5)');
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
		}).toString().areEqual('$name(2, 3, 4, 5)');
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
		}).toString().areEqual('$name(1, 3, 5)');
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
		}).toString().areEqual('$name(1, 2, 3, 4, 5)');
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

	// Find Index Of

	@Test
	public function when_findIndexOf__should_return_1_for_value_2() : Void {
		actual.findIndexOf(function(x) {
			return x == 2;
		}).areEqual(1);
	}

	@Test
	public function when_findIndexOf__should_return_2_for_value_3() : Void {
		actual.findIndexOf(function(x) {
			return x == 3;
		}).areEqual(2);
	}

	@Test
	public function when_findIndexOf_with_false__should_return_minus_1() : Void {
		actual.findIndexOf(function(x) {
			return false;
		}).areEqual(-1);
	}

	// Fold Left

	@Test
	public function when_foldLeft__should_foldLeft_should_return_10() : Void {
		actual.foldLeft(0, function (a, b) {
			return a + b;
		}).areEqual(Some(15));
	}

	@Test
	public function when_foldLeft__should_foldLeft_should_return_11() : Void {
		actual.foldLeft(1, function (a, b) {
			return a + b;
		}).areEqual(Some(16));
	}

	@Test
	public function when_foldLeft__should_call_foldLeft() : Void {
		actual.foldLeft(0, function(x, y) {
			return 0;
		}).areEqual(Some(0));
	}

	@Test
	public function when_foldLeft__should_foldLeft_should_return_abcde() : Void {
		alpha.foldLeft('', function (a, b) {
			return a + b;
		}).areEqual(Some('abcde'));
	}

	// Fold Right

	@Test
	public function when_foldRight__should_foldRight_should_return_10() : Void {
		actual.foldRight(0, function (a, b) {
			return a + b;
		}).areEqual(Some(15));
	}

	@Test
	public function when_foldRight__should_foldRight_should_return_11() : Void {
		actual.foldRight(1, function (a, b) {
			return a + b;
		}).areEqual(Some(16));
	}

	@Test
	public function when_foldRight__should_call_foldRight() : Void {
		actual.foldRight(0, function(x, y) {
			return 0;
		}).areEqual(Some(0));
	}

	@Test
	public function when_foldRight__should_foldRight_should_return_abcde() : Void {
		alpha.foldRight('', function (a, b) {
			return a + b;
		}).areEqual(Some('edcba'));
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

	// Index Of

	@Test
	public function when_indexOf__should_return_1_for_value_2() : Void {
		actual.indexOf(2).areEqual(1);
	}

	@Test
	public function when_indexOf__should_return_2_for_value_3() : Void {
		actual.indexOf(3).areEqual(2);
	}

	@Test
	public function when_indexOf_99__should_return_minus_1() : Void {
		actual.indexOf(99).areEqual(-1);
	}

	// Map

	@Test
	public function when_map__should_return_list() : Void {
		actual.map(function(value) {
			return value + 1.1;
		}).toString().areEqual('$name(2.1, 3.1, 4.1, 5.1, 6.1)');
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

	// Partition

	@Test
	public function when_partition__should_return_isNotNull() : Void {
		actual.partition(function(value) {
			return true;
		}).isNotNull();
	}

	@Test
	public function when_partition__should_return_a_Tuple2() : Void {
		actual.partition(function(value) {
			return value % 2 == 0;
		}).toString(function (x) {
			return x.toString();
		}, function (x) {
			return x.toString();
		}).areEqual('($name(2, 4), $name(1, 3, 5))');
	}

	@Test
	public function when_partition__should_return_a_ITuple2_and__1_is_List() : Void {
		actual.partition(function(value) {
			return true;
		})._1().toString().areEqual('$name(1, 2, 3, 4, 5)');
	}

	@Test
	public function when_partition_false__should_return_a_ITuple2_and__2_is_List() : Void {
		actual.partition(function(value) {
			return false;
		})._2().toString().areEqual('$name(1, 2, 3, 4, 5)');
	}

	@Test
	public function when_partition_false__should_return_a_ITuple2_and__1_is_empty() : Void {
		actual.partition(function(value) {
			return false;
		})._1().isEmpty().isTrue();
	}

	@Test
	public function when_partition_false__should_return_a_ITuple2_and__2_is_empty() : Void {
		actual.partition(function(value) {
			return true;
		})._2().isEmpty().isTrue();
	}

	@Test
	public function when_partition__should_return_a_ITuple2_and__1_is_IList_of_size_2() : Void {
		actual.partition(function(value) {
			return value % 2 == 0;
		})._1().size().areEqual(2);
	}

	@Test
	public function when_partition__should_return_a_ITuple2_and__2_is_Nil() : Void {
		actual.partition(function(value) {
			return true;
		})._2().toString().areEqual(emptyName);
	}

	@Test
	public function when_partition__should_return_a_ITuple2_and__2_is_List_of_size_3() : Void {
		actual.partition(function(value) {
			return value % 2 == 0;
		})._2().size().areEqual(3);
	}

	// Reduce Left

	@Test
	public function when_reduceLeft__should_return_Option() : Void {
		actual.reduceLeft(function(a, b) {
			return a + b;
		}).areEqual(Some(15));
	}

	@Test
	public function when_reduceLeft__should_return_Some() : Void {
		actual.reduceLeft(function(a, b) {
			return -1;
		}).areEqual(Some(-1));
	}

	@Test
	public function when_reduceLeft__should_call_method() : Void {
		var called = false;
		actual.reduceLeft(function(a, b) {
			called = true;
			return -1;
		});
		called.isTrue();
	}

	@Test
	public function when_reduceLeft__should_return_Option_aabcde() : Void {
		alpha.reduceLeft(function(a, b) {
			return a + b;
		}).areEqual(Some('abcde'));
	}

	// Reduce Right

	@Test
	public function when_reduceRight__should_return_Option() : Void {
		actual.reduceRight(function(a, b) {
			return a + b;
		}).areEqual(Some(15));
	}

	@Test
	public function when_reduceRight__should_return_Some() : Void {
		actual.reduceRight(function(a, b) {
			return -1;
		}).areEqual(Some(-1));
	}

	@Test
	public function when_reduceRight__should_call_method() : Void {
		var called = false;
		actual.reduceRight(function(a, b) {
			called = true;
			return -1;
		});
		called.isTrue();
	}

	@Test
	public function when_reduceRight__should_return_Option_eedcba() : Void {
		alpha.reduceRight(function(a, b) {
			return a + b;
		}).areEqual(Some('edcba'));
	}

	// Take Left

	@Test
	public function when_takeLeft_0__should_return_isNotNull() : Void {
		actual.takeLeft(0).isNotNull();
	}

	@Test
	public function when_takeLeft_0___should_return_valid_Nil() : Void {
		actual.takeLeft(0).toString().areEqual(emptyName);
	}

	@Test
	public function when_takeLeft_0__should_return_size_0() : Void {
		actual.takeLeft(0).size().areEqual(0);
	}

	@Test
	public function when_takeLeft_1__should_return_size_1() : Void {
		actual.takeLeft(1).size().areEqual(1);
	}

	@Test
	public function when_takeLeft_1__should_return_1_2_3_4() : Void {
		actual.takeLeft(4).toString().areEqual('$name(1, 2, 3, 4)');
	}

	@Test
	public function when_takeLeft_10__should_return_size_5() : Void {
		actual.takeLeft(10).size().areEqual(5);
	}

	@Test
	public function when_takeLeft_1__should_return_1() : Void {
		actual.takeLeft(1).get(0).areEqual(Some(1));
	}

	@Test
	public function when_takeLeft_10__should_last_return_5() : Void {
		actual.takeLeft(10).last().areEqual(Some(5));
	}

	@Test
	public function when_takeLeft_minus_1__should_throw_error() : Void {
		var called = try {
			actual.takeLeft(-1);
			false;
		} catch(error : Dynamic){
			true;
		}
		called.isTrue();
	}

	// Take Right

	@Test
	public function when_takeRight_0__should_return_isNotNull() : Void {
		actual.takeRight(0).isNotNull();
	}

	@Test
	public function when_takeRight_0___should_return_valid_Nil() : Void {
		actual.takeRight(0).areIterablesEqual(empty);
	}

	@Test
	public function when_takeRight_0_toString__should_return_valid_empty() : Void {
		actual.takeRight(0).toString().areEqual(emptyName);
	}

	@Test
	public function when_takeRight_0__should_return_size_0() : Void {
		actual.takeRight(0).size().areEqual(0);
	}

	@Test
	public function when_takeRight_1__should_return_size_1() : Void {
		actual.takeRight(1).size().areEqual(1);
	}

	@Test
	public function when_takeRight_4__should_return_size_2_3_4_5() : Void {
		actual.takeRight(4).toString().areEqual('$name(2, 3, 4, 5)');
	}

	@Test
	public function when_takeRight_10__should_return_size_5() : Void {
		actual.takeRight(10).size().areEqual(5);
	}

	@Test
	public function when_takeRight_1__should_return_5() : Void {
		actual.takeRight(1).get(0).areEqual(Some(5));
	}

	@Test
	public function when_takeRight_10__should_last_return_5() : Void {
		actual.takeRight(10).last().areEqual(Some(5));
	}

	@Test
	public function when_takeRight_minus_1__should_throw_error() : Void {
		var called = try {
			actual.takeRight(-1);
			false;
		} catch(error : Dynamic){
			true;
		}
		called.isTrue();
	}

	// Take While

	@Test
	public function when_takeWhile__should_return_isNotNull() : Void {
		actual.takeWhile(function(value) {
			return true;
		}).isNotNull();
	}

	@Test
	public function when_takeWhile__should_return_valid_IList() : Void {
		actual.takeWhile(function(value) {
			return true;
		}).toString().areEqual('$name(1, 2, 3, 4, 5)');
	}

	@Test
	public function when_takeWhile__should_return_size_4() : Void {
		actual.takeWhile(function(value) {
			return true;
		}).size().areEqual(actualTotal);
	}

	@Test
	public function when_takeWhile__should_return_size_0() : Void {
		actual.takeWhile(function(value) {
			return false;
		}).size().areEqual(0);
	}

	@Test
	public function when_takeWhile__should_return_nil() : Void {
		actual.takeWhile(function(value) {
			return false;
		}).areIterablesEqual(empty);
	}

	@Test
	public function when_takeWhile_toString__should_return_empty_name() : Void {
		actual.takeWhile(function(value) {
			return false;
		}).toString().areEqual(emptyName);
	}

	@Test
	public function when_takeWhile__should_return_size_2() : Void {
		actual.takeWhile(function(value) {
			return value <= 2;
		}).size().areEqual(2);
	}

	@Test
	public function when_takeWhile__should_return_1_2() : Void {
		actual.takeWhile(function(value) {
			return value <= 2;
		}).toString().areEqual('$name(1, 2)');
	}

	@Test
	public function when_takeWhile__should_call_method() : Void {
		var called = false;
		actual.takeWhile(function(value) {
			called = true;
			return true;
		});
		called.isTrue();
	}

	// Zip

	@Test
	public function when_zip__should_not_be_null() : Void {
		actual.zip(empty).isNotNull();
	}

	@Test
	public function when_zip__should_be_be_size_0() : Void {
		actual.zip(empty).size().areEqual(0);
	}

	@Test
	public function when_zip__should_be_be_size_4() : Void {
		actual.zip(other).size().areEqual(otherTotal);
	}

	@Test
	public function when_zip__should_calling_get_0_return_tuple2() : Void {
		actual.zip(other).get(0).areEqual(Some(tuple2(1, 6)));
	}

	@Test
	public function when_zip__should_calling_get_3_return_tuple2() : Void {
		actual.zip(other).get(3).areEqual(Some(tuple2(4, 9)));
	}

	@Test
	public function when_zip__should_calling_toString() : Void {
		actual.zip(other).toString(function(x) {
			return x.toString();
		}).areEqual('$name((1, 6), (2, 7), (3, 8), (4, 9))');
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
		actual.init().toString().areEqual('$name(1, 2, 3, 4)');
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
		}).areEqual('$name((1, 0), (2, 1), (3, 2), (4, 3), (5, 4))');
	}

	// Has Defined Size

	@Test
	public function should_have_a_defined_size():Void {
		actual.hasDefinedSize().isTrue();
	}
}
