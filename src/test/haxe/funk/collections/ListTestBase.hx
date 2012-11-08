package funk.collections;

import funk.collections.IList;
import funk.collections.immutable.ListUtil;
import funk.errors.ArgumentError;
import funk.errors.NoSuchElementError;
import funk.errors.RangeError;
import funk.option.Option;
import funk.tuple.Tuple2;
import funk.Wildcard;

import massive.munit.Assert;
import massive.munit.AssertExtensions;

using funk.collections.immutable.ListUtil;
using funk.option.Option;
using funk.tuple.Tuple2;
using funk.Wildcard;

using massive.munit.Assert;
using massive.munit.AssertExtensions;

class ListTestBase {

	public var actual : IList<Dynamic>;

	public var expected : IList<Dynamic>;

	public var other : IList<Dynamic>;

	public var filledList : IList<Dynamic>;

	public var listClassName : String;

	private function generateIntList(size : Int) : IList<Int> {
		var count = 0;
		return size.fill(function() : Int {
			return count++;
		});
	}

	@Test
	public function should_be_not_empty():Void {
		actual.nonEmpty.isTrue();
	}

	@Test
	public function should_be_empty():Void {
		actual.isEmpty.isFalse();
	}

	@Test
	public function should_have_5_size():Void {
		var value = 5;
		generateIntList(value).size.areEqual(value);
	}

	@Test
	public function should_have_99999_size():Void {
		var value = 9999;
		generateIntList(value).size.areEqual(value);
	}

	@Test
	public function should_have_a_defined_size():Void {
		actual.hasDefinedSize.isTrue();
	}

	@Test
	public function should_call_count() : Void {
		var exp = 5;
		var act = 0;
		generateIntList(exp).count(function(x) {
			act++;
			return true;
		});
		act.areEqual(exp);
	}

	@Test
	public function should_count_be_same_as_expected() : Void {
		var exp = 5;
		var act = generateIntList(exp).count(function(x) {
			return true;
		});
		act.areEqual(exp);
	}

	@Test
	public function should_count_be_0() : Void {
		var exp = 0;
		var act = generateIntList(exp).count(function(x) {
			return false;
		});
		act.areEqual(exp);
	}

	@Test
	public function when_drop_0__return_same_list() : Void {
		actual.drop(0).areEqual(actual);
	}

	@Test
	public function when_drop_3__return_IList() : Void {
		actual.drop(2).isType(IList);
	}

	@Test
	public function when_drop_2__return_size_2() : Void {
		actual.drop(2).size.areEqual(2);
	}

	@Test
	public function when_drop_2__return_get_0_is_2() : Void {
		var opt : IOption<Int> = generateIntList(5).drop(2).get(0);
		opt.get().areEqual(2);
	}

	@Test
	public function when_drop_2__return_get_1_is_3() : Void {
		var opt : IOption<Int> = generateIntList(5).drop(2).get(1);
		opt.get().areEqual(3);
	}

	@Test
	public function when_drop_2_then_1__return_get_0_is_3() : Void {
		var opt : IOption<Int> = generateIntList(5).drop(2).drop(1).get(0);
		opt.get().areEqual(3);
	}

	@Test
	public function when_drop_on_list__throw_argument_when_passing_minus_to_drop() : Void {
		var called = try {
			actual.drop(-1);
			false;
		} catch(error : ArgumentError) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function when_dropRight_0_on_list__return_same_list() : Void {
		actual.dropRight(0).areEqual(actual);
	}

	@Test
	public function when_dropRight_1_on_list__return_and_get_0_equals_0() : Void {
		generateIntList(5).dropRight(1).get(0).get().areEqual(0);
	}

	@Test
	public function when_dropRight_2_on_list__return_and_get_2_equals_2() : Void {
		generateIntList(5).dropRight(2).get(2).get().areEqual(2);
	}

	@Test
	public function when_dropRight_on_list__throw_argument_when_passing_minus_to_dropRight() : Void {
		var called = try {
			actual.dropRight(-1);
			false;
		} catch(error : ArgumentError) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function when_dropWhile__return_not_null() : Void {
		generateIntList(5).dropWhile(function(x : Int):Bool {
			return x < 2;
		}).isNotNull();
	}

	@Test
	public function when_dropWhile__return_is_type_of_list() : Void {
		generateIntList(5).dropWhile(function(x : Int):Bool {
			return x < 2;
		}).isType(IList);
	}

	@Test
	public function when_dropWhile__return_size_is_3() : Void {
		generateIntList(5).dropWhile(function(x : Int):Bool {
			return x < 2;
		}).size.areEqual(3);
	}

	@Test
	public function when_dropWhile__return_get_2_equals_4() : Void {
		generateIntList(5).dropWhile(function(x : Int):Bool {
			return x < 2;
		}).get(2).get().areEqual(4);
	}


	@Test
	public function when_exists__should_return_true_when_calling_exists() : Void {
		actual.exists(function(x : Int):Bool {
			return x == 2;
		}).isTrue();
	}

	@Test
	public function when_filter__should_return_list() : Void {
		actual.filter(function(x : Dynamic):Bool {
			return x == 1;
		}).isType(IList);
	}

	@Test
	public function when_filter__should_return_list_of_size_1() : Void {
		actual.filter(function(x : Dynamic):Bool {
			return x == 1;
		}).size.areEqual(1);
	}

	@Test
	public function when_filter__should_return_even_list_of_size_2() : Void {
		actual.filter(function(x : Dynamic):Bool {
			return x % 2 == 0;
		}).size.areEqual(2);
	}

	@Test
	public function when_filterNot__should_return_list() : Void {
		actual.filterNot(function(x : Dynamic):Bool {
			return x == 1;
		}).isType(IList);
	}

	@Test
	public function when_filterNot__should_return_list_of_size_4() : Void {
		actual.filterNot(function(x : Dynamic):Bool {
			return x == 1;
		}).size.areEqual(3);
	}

	@Test
	public function when_filterNot__should_return_even_list_of_size_2() : Void {
		actual.filterNot(function(x : Dynamic):Bool {
			return x % 2 == 0;
		}).size.areEqual(2);
	}

	@Test
	public function when_find__should_return_Option() : Void {
		actual.find(function(x : Dynamic):Bool {
			return x == 2;
		}).isType(IOption);
	}

	@Test
	public function when_find__should_return_Some() : Void {
		actual.find(function(x : Dynamic):Bool {
			return x == 2;
		}).isDefined().isTrue();
	}

	@Test
	public function when_find__should_call_find() : Void {
		var called = false;
		actual.find(function(x : Dynamic):Bool {
			called = true;
			return x == 2;
		});
		called.isTrue();
	}

	@Test
	public function when_findIndexOf__should_return_1_for_value_2() : Void {
		actual.findIndexOf(function(x : Dynamic):Bool {
			return x == 2;
		}).areEqual(1);
	}

	@Test
	public function when_findIndexOf__should_return_2_for_value_3() : Void {
		actual.findIndexOf(function(x : Dynamic):Bool {
			return x == 3;
		}).areEqual(2);
	}

	@Test
	public function when_indexOf__should_return_1_for_value_2() : Void {
		actual.indexOf(2).areEqual(1);
	}

	@Test
	public function when_indexOf__should_return_2_for_value_3() : Void {
		actual.indexOf(3).areEqual(2);
	}




	@Test
	public function when_zip__should_not_be_null() : Void {
		actual.zip(other).isNotNull();
	}

	@Test
	public function when_zip__should_be_be_size_0() : Void {
		actual.zip(other).size.areEqual(0);
	}

	@Test
	public function when_zip__should_be_be_size_4() : Void {
		actual.zip(filledList).size.areEqual(4);
	}

	@Test
	public function when_zip__should_calling_get_0_return_tuple2() : Void {
		actual.zip(filledList).get(0).get().isType(ITuple2);
	}

	@Test
	public function when_zip__should_calling_get_3_return_tuple2() : Void {
		actual.zip(filledList).get(3).get().isType(ITuple2);
	}

	@Test
	public function when_zip__should_calling_get_3_return_tuple2_and__1_equals_4() : Void {
		actual.zip(filledList).get(3).get()._1.areEqual(4);
	}

	@Test
	public function when_zip__should_calling_get_2_return_tuple2_and__2_equals_3() : Void {
		actual.zip(filledList).get(2).get()._2.areEqual(3);
	}

	@Test
	public function when_map__should_return_list() : Void {
		actual.map(function(value : Int) : Float {
			return value + 1;
		}).isType(IList);
	}

	@Test
	public function when_map__should_return_list_of_size_4() : Void {
		actual.map(function(value : Int) : Float {
			return value + 1;
		}).size.areEqual(4);
	}

	@Test
	public function when_map__should_calling_get_0_return_2() : Void {
		actual.map(function(value : Int) : Float {
			return value + 1;
		}).get(0).get().areEqual(2);
	}

	@Test
	public function when_map__should_calling_get_1_return_3() : Void {
		actual.map(function(value : Int) : Float {
			return value + 1;
		}).get(1).get().areEqual(3);
	}

	@Test
	public function when_map__should_calling_get_2_return_4() : Void {
		actual.map(function(value : Int) : Float {
			return value + 1;
		}).get(2).get().areEqual(4);
	}

	@Test
	public function when_map__should_calling_get_3_return_5() : Void {
		actual.map(function(value : Int) : Float {
			return value + 1;
		}).get(3).get().areEqual(5);
	}

	@Test
	public function when_map__should_calling_get_0_return_Hello1() : Void {
		actual.map(function(value : Int) : String {
			return "Hello" + value;
		}).get(0).get().areEqual("Hello1");
	}

	@Test
	public function when_map__should_calling_get_0_return_same_instance_as_past_in() : Void {
		var instance = {};
		Assert.areEqual(actual.map(function(value : Int) : Dynamic {
			return instance;
		}).get(0).get(), instance);
	}

	@Test
	public function when_flatMap__should_return_a_list_containing_concat_lists() : Void {
		var result = actual.flatMap(function(x : Dynamic):IList<Dynamic> {
			return expected;
		});
		result.equals([1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4].toList()).isTrue();
	}

	@Test
	public function when_find__should_return_size_of_16() : Void {
		actual.flatMap(function(x : Dynamic):IList<Dynamic> {
			return expected;
		}).size.areEqual(16);
	}

	@Test
	public function when_flatten__should_flatten_list() : Void {
		actual.flatten.equals(filledList).isTrue();
	}

	@Test
	public function when_flatten__should_flatten_sublists() : Void {
		var a = [[1, 2, 3, 4].toList(), [5, 6, 7, 8].toList(), [9, 10].toList()].toList();
		a.flatten.equals([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].toList()).isTrue();
	}

	@Test
	public function when_fold__should_foldLeft_should_return_10() : Void {
		actual.foldLeft(0, _.plus_).areEqual(10);
	}

	@Test
	public function when_fold__should_foldLeft_should_return_11() : Void {
		actual.foldLeft(1, _.plus_).areEqual(11);
	}

	@Test
	public function when_fold__should_call_foldLeft() : Void {
		actual.foldLeft(0, function(x:Int, y:Int):Int {
			return 0;
		}).areEqual(0);
	}

	@Test
	public function when_fold__should_foldRight_should_return_10() : Void {
		actual.foldRight(0, _.plus_).areEqual(10);
	}

	@Test
	public function when_fold__should_foldRight_should_return_11() : Void {
		actual.foldRight(1, _.plus_).areEqual(11);
	}

	@Test
	public function when_fold__should_call_foldRight() : Void {
		actual.foldRight(0, function(x:Int, y:Int):Int {
			return 0;
		}).areEqual(0);
	}

	@Test
	public function when_forall__should_return_true() : Void {
		actual.forall(function(value : Int) : Bool {
			return true;
		}).isTrue();
	}

	@Test
	public function when_forall__should_return_false_if_value_is_less_than_2() : Void {
		actual.forall(function(value : Int) : Bool {
			return value == 2;
		}).isFalse();
	}

	@Test
	public function when_foreach__should_run_function() : Void {
		var called = false;
		actual.foreach(function(value : Int) : Void {
			called = true;
		});
		called.isTrue();
	}

	@Test
	public function when_partition__should_return_isNotNull() : Void {
		actual.partition(function(value : Int) : Bool {
			return true;
		}).isNotNull();
	}

	@Test
	public function when_partition__should_return_a_ITuple2() : Void {
		actual.partition(function(value : Int) : Bool {
			return true;
		}).isType(ITuple2);
	}

	@Test
	public function when_partition__should_return_a_ITuple2_and__1_is_IList() : Void {
		actual.partition(function(value : Int) : Bool {
			return true;
		})._1.isType(IList);
	}

	@Test
	public function when_partition__should_return_a_ITuple2_and__1_is_IList_of_size_2() : Void {
		actual.partition(function(value : Int) : Bool {
			return value % 2 == 0;
		})._1.size.areEqual(2);
	}

	@Test
	public function when_partition__should_return_a_ITuple2_and__2_is_IList() : Void {
		actual.partition(function(value : Int) : Bool {
			return true;
		})._2.isType(IList);
	}

	@Test
	public function when_partition__should_return_a_ITuple2_and__2_is_IList_of_size_2() : Void {
		actual.partition(function(value : Int) : Bool {
			return value % 2 == 0;
		})._2.size.areEqual(2);
	}

	@Test
	public function when_reduceRight__should_return_Option() : Void {
		actual.reduceRight(function(a:Int, b:Int):Int {
			return a + b;
		}).isType(IOption);
	}

	@Test
	public function when_reduceRight__should_return_Some() : Void {
		actual.reduceRight(function(a:Int, b:Int):Int {
			return -1;
		}).isDefined().isTrue();
	}

	@Test
	public function when_reduceRight__should_call_method() : Void {
		var called = false;
		actual.reduceRight(function(a:Int, b:Int):Int {
			called = true;
			return -1;
		});
		called.isTrue();
	}

	@Test
	public function when_reduceRight__should_return_10() : Void {
		Assert.areEqual(actual.reduceRight(function(a:Int, b:Int):Int {
			return a + b;
		}).get(), 10);
	}

	@Test
	public function when_reduceRight__should_return_fedcba() : Void {
		Assert.areEqual("abcdef".toList().reduceRight(function(a:String, b:String):String {
			return a + b;
		}).get(), "fedcba");
	}

	@Test
	public function when_reduceLeft__should_return_Option() : Void {
		actual.reduceLeft(function(a:Int, b:Int):Int {
			return a + b;
		}).isType(IOption);
	}

	@Test
	public function when_reduceLeft__should_return_Some() : Void {
		actual.reduceLeft(function(a:Int, b:Int):Int {
			return -1;
		}).isDefined().isTrue();
	}

	@Test
	public function when_reduceLeft__should_call_method() : Void {
		var called = false;
		actual.reduceLeft(function(a:Int, b:Int):Int {
			called = true;
			return -1;
		});
		called.isTrue();
	}

	@Test
	public function when_reduceLeft__should_return_10() : Void {
		Assert.areEqual(actual.reduceLeft(function(a:Int, b:Int):Int {
			return a + b;
		}).get(), 10);
	}

	@Test
	public function when_reduceLeft__should_return_abcdef() : Void {
		Assert.areEqual("abcdef".toList().reduceLeft(function(a:String, b:String):String {
			return a + b;
		}).get(), "abcdef");
	}

	@Test
	public function when_take_0__should_return_isNotNull() : Void {
		actual.take(0).isNotNull();
	}

	@Test
	public function when_take_0___should_return_valid_IList() : Void {
		actual.take(0).isType(IList);
	}

	@Test
	public function when_take_0__should_return_size_0() : Void {
		actual.take(0).size.areEqual(0);
	}

	@Test
	public function when_take_1__should_return_size_1() : Void {
		actual.take(1).size.areEqual(1);
	}

	@Test
	public function when_take_10__should_return_size_4() : Void {
		actual.take(10).size.areEqual(4);
	}

	@Test
	public function when_take_1__should_return_1() : Void {
		Assert.areEqual(actual.take(1).get(0).get(), 1);
	}

	@Test
	public function when_take_10__should_last_return_4() : Void {
		Assert.areEqual(actual.take(10).last.get(), 4);
	}

	@Test
	public function when_take_minus_1__should_throw_error() : Void {
		var called = try {
			actual.take(-1);
			false;
		} catch(error : ArgumentError){
			true;
		}
		called.isTrue();
	}

	@Test
	public function when_takeRight_0__should_return_isNotNull() : Void {
		actual.takeRight(0).isNotNull();
	}

	@Test
	public function when_takeRight_0___should_return_valid_IList() : Void {
		actual.takeRight(0).isType(IList);
	}

	@Test
	public function when_takeRight_0__should_return_size_0() : Void {
		actual.takeRight(0).size.areEqual(0);
	}

	@Test
	public function when_takeRight_1__should_return_size_1() : Void {
		actual.takeRight(1).size.areEqual(1);
	}

	@Test
	public function when_takeRight_10__should_return_size_4() : Void {
		actual.takeRight(10).size.areEqual(4);
	}

	@Test
	public function when_takeRight_1__should_return_4() : Void {
		Assert.areEqual(actual.takeRight(1).get(0).get(), 4);
	}

	@Test
	public function when_takeRight_10__should_last_return_4() : Void {
		Assert.areEqual(actual.takeRight(10).last.get(), 4);
	}

	@Test
	public function when_takeRight_minus_1__should_throw_error() : Void {
		var called = try {
			actual.takeRight(-1);
			false;
		} catch(error : ArgumentError){
			true;
		}
		called.isTrue();
	}

	@Test
	public function when_takeWhile__should_return_isNotNull() : Void {
		actual.takeWhile(function(value : Int) : Bool {
			return true;
		}).isNotNull();
	}

	@Test
	public function when_takeWhile__should_return_valid_IList() : Void {
		actual.takeWhile(function(value : Int) : Bool {
			return true;
		}).isType(IList);
	}

	@Test
	public function when_takeWhile__should_return_size_4() : Void {
		actual.takeWhile(function(value : Int) : Bool {
			return true;
		}).size.areEqual(4);
	}

	@Test
	public function when_takeWhile__should_return_size_2() : Void {
		actual.takeWhile(function(value : Int) : Bool {
			return value <= 2;
		}).size.areEqual(2);
	}

	@Test
	public function when_takeWhile__should_call_method() : Void {
		var called = false;
		actual.takeWhile(function(value : Int) : Bool {
			called = true;
			return true;
		});
		called.isTrue();
	}

	@Test
	public function when_get_0__should_return_Option() : Void {
		actual.get(0).isType(IOption);
	}

	@Test
	public function when_get_0__should_return_None() : Void {
		actual.get(0).isDefined().isTrue();
	}

	@Test
	public function when_get_0__should_return_1() : Void {
		Assert.areEqual(actual.get(0).get(), 1);
	}

	@Test
	public function when_take__should_not_return_null() : Void {
		actual.take(0).isNotNull();
	}

	@Test
	public function when_take__should_return_list() : Void {
		actual.take(0).areEqual(other);
	}

	@Test
	public function when_take__should_return_list_of_size_0() : Void {
		actual.take(0).size.areEqual(0);
	}

	@Test
	public function when_take_with_1__should_return_list_with_1() : Void {
		Assert.areEqual(actual.take(1).get(0).get(), 1);
	}

	@Test
	public function when_take_with_2__should_return_list_with_2() : Void {
		Assert.areEqual(actual.take(2).get(1).get(), 2);
	}

	@Test
	public function when_takeRight__should_not_return_null() : Void {
		actual.takeRight(0).isNotNull();
	}

	@Test
	public function when_takeRight__should_return_list() : Void {
		actual.takeRight(0).areEqual(other);
	}

	@Test
	public function when_takeRight__should_return_list_of_size_0() : Void {
		actual.takeRight(0).size.areEqual(0);
	}

	@Test
	public function when_takeRight_with_1__should_return_list_with_4() : Void {
		Assert.areEqual(actual.takeRight(1).get(0).get(), 4);
	}

	@Test
	public function when_takeRight_with_2__should_return_list_with_4() : Void {
		Assert.areEqual(actual.takeRight(2).get(1).get(), 4);
	}

	@Test
	public function when_contains__should_not_contain_null() : Void {
		actual.contains(null).isFalse();
	}

	@Test
	public function when_contains__should_not_contain_true() : Void {
		actual.contains(true).isFalse();
	}

	@Test
	public function when_contains__should_not_contain_object() : Void {
		actual.contains({}).isFalse();
	}

	@Test
	public function when_contains__should_not_contain_array() : Void {
		actual.contains([]).isFalse();
	}

	@Test
	public function when_contains__should_contain_1() : Void {
		actual.contains(1).isTrue();
	}

	@Test
	public function when_contains__should_contain_2() : Void {
		actual.contains(2).isTrue();
	}

	@Test
	public function when_contains__should_contain_3() : Void {
		actual.contains(3).isTrue();
	}

	@Test
	public function when_contains__should_contain_4() : Void {
		actual.contains(4).isTrue();
	}

	@Test
	public function when_toArray__should_not_be_null() : Void {
		actual.toArray.isNotNull();
	}

	@Test
	public function when_toArray__should_be_length_4() : Void {
		actual.toArray.length.areEqual(4);
	}

	@Test
	public function when_toArray__should_value_0_be_1() : Void {
		Assert.areEqual(actual.toArray[0], 1);
	}

	@Test
	public function when_toArray__should_value_1_be_2() : Void {
		Assert.areEqual(actual.toArray[1], 2);
	}

	@Test
	public function when_toArray__should_value_2_be_3() : Void {
		Assert.areEqual(actual.toArray[2], 3);
	}

	@Test
	public function when_toArray__should_value_3_be_4() : Void {
		Assert.areEqual(actual.toArray[3], 4);
	}

	@Test
	public function when_head__should_not_be_null() : Void {
		actual.head.isNotNull();
	}

	@Test
	public function when_head__should_be_1() : Void {
		Assert.areEqual(actual.head, 1);
	}

	@Test
	public function when_headOption__should_be_Option() : Void {
		actual.headOption.isType(IOption);
	}

	@Test
	public function when_headOption__should_be_Some() : Void {
		actual.headOption.isDefined().isTrue();
	}

	@Test
	public function when_headOption__should_be_Some_of_value_1() : Void {
		Assert.areEqual(actual.headOption.get(), 1);
	}

	@Test
	public function when_indices__should_not_be_null() : Void {
		actual.indices.isNotNull();
	}

	@Test
	public function when_indices__should_be_equal_0_1_2_3() : Void {
		actual.indices.toList().equals([0, 1, 2, 3].toList()).isTrue();
	}

	@Test
	public function when_init__should_not_be_null() : Void {
		actual.init.isNotNull();
	}

	@Test
	public function when_init__should_size_should_be_3() : Void {
		actual.init.size.areEqual(3);
	}

	@Test
	public function when_init__should_be_equal_4() : Void {
		actual.init.equals([1, 2, 3].toList()).isTrue();
	}

	@Test
	public function when_last__should_not_be_null() : Void {
		actual.last.isNotNull();
	}

	@Test
	public function when_last__should_be_equal_to_Option() : Void {
		actual.last.isType(IOption);
	}

	@Test
	public function when_last__should_be_equal_to_Some() : Void {
		actual.last.isDefined().isTrue();
	}

	@Test
	public function when_last__should_be_equal_to_Some_value_of_4() : Void {
		Assert.areEqual(actual.last.get(), 4);
	}

	@Test
	public function when_reverse__should_not_be_null() : Void {
		actual.reverse.isNotNull();
	}

	@Test
	public function when_reverse__should_be_size_of_4() : Void {
		actual.reverse.size.areEqual(4);
	}

	@Test
	public function when_reverse__should_be_equal_to_4_3_2_1() : Void {
		actual.reverse.equals([4, 3, 2, 1].toList()).isTrue();
	}

	@Test
	public function when_tail__should_not_be_null() : Void {
		actual.tail.isNotNull();
	}

	@Test
	public function when_tail__should_be_2_3_4() : Void {
		actual.tail.equals([2, 3, 4].toList()).isTrue();
	}

	@Test
	public function when_tailOption__should_be_Option() : Void {
		actual.tailOption.isType(IOption);
	}

	@Test
	public function when_tailOption__should_be_Some() : Void {
		actual.tailOption.isDefined().isTrue();
	}

	@Test
	public function when_tailOption__should_be_Some_value_of_2_3_4() : Void {
		actual.tailOption.get().equals([2, 3, 4].toList()).isTrue();
	}

	@Test
	public function when_zipWithIndex__should_not_be_null() : Void {
		actual.zipWithIndex.isNotNull();
	}

	@Test
	public function when_zipWithIndex__should_be_equal_to_nil() : Void {
		actual.zipWithIndex.equals([	tuple2(1, 0).toInstance(),
										tuple2(2, 1).toInstance(),
										tuple2(3, 2).toInstance(),
										tuple2(4, 3).toInstance()
										].toList()).isTrue();
	}

	@Test
	public function when_productArity__should_be_equal_to_4() : Void {
		actual.productArity.areEqual(4);
	}

	@Test
	public function when_calling_productElement__should_throw_RangeError() : Void {
		var called = try {
			actual.productElement(5);
			false;
		} catch(e : RangeError) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function when_calling_append__should_not_be_null() : Void {
		actual.append(5).isNotNull();
	}

	@Test
	public function when_calling_append__should_be_size_5() : Void {
		actual.append(5).size.areEqual(5);
	}

	@Test
	public function when_calling_append__should_equal_1_2_3_4_5() : Void {
		actual.append(5).equals([1, 2, 3, 4, 5].toList()).isTrue();
	}

	@Test
	public function when_calling_appendIterable__should_not_be_null() : Void {
		actual.appendIterable({iterator: filledList.productIterator}).isNotNull();
	}

	@Test
	public function when_calling_appendIterable__should_be_size_8() : Void {
		actual.appendIterable({iterator: filledList.productIterator}).size.areEqual(8);
	}

	@Test
	public function when_calling_appendIterable__should_be_size_1_2_3_4_1_2_3_4() : Void {
		actual.appendIterable({iterator: filledList.productIterator}).equals([1, 2, 3, 4, 1, 2, 3, 4].toList()).isTrue();
	}

	@Test
	public function when_calling_iterator__should_not_be_null() : Void {
		actual.appendIterator(filledList.productIterator()).isNotNull();
	}

	@Test
	public function when_calling_iterator__should_be_size_8() : Void {
		actual.appendIterator(filledList.productIterator()).size.areEqual(8);
	}

	@Test
	public function when_calling_appendAll__should_not_be_null() : Void {
		actual.appendAll(other).isNotNull();
	}

	@Test
	public function when_calling_appendAll__should_be_size_8() : Void {
		actual.appendAll(filledList).size.areEqual(8);
	}

	@Test
	public function when_calling_appendAll__should_be_1_2_3_4_1_2_3_4() : Void {
		actual.appendAll(filledList).equals([1, 2, 3, 4, 1, 2, 3, 4].toList()).isTrue();
	}

	@Test
	public function when_calling_prepend__should_not_be_null() : Void {
		actual.prepend(1).isNotNull();
	}

	@Test
	public function when_calling_prepend__should_be_size_1() : Void {
		actual.prepend(5).size.areEqual(5);
	}

	@Test
	public function when_calling_prepend__should_be_5_1_2_3_4() : Void {
		actual.prepend(5).equals([5, 1, 2, 3, 4].toList()).isTrue();
	}

	@Test
	public function when_calling_prependIterable__should_not_be_null() : Void {
		actual.prependIterable({iterator: filledList.productIterator}).isNotNull();
	}

	@Test
	public function when_calling_prependIterable__should_be_size_8() : Void {
		actual.prependIterable({iterator: filledList.productIterator}).size.areEqual(8);
	}

	@Test
	public function when_calling_prependIterable__should_be_1_2_3_4_1_2_3_4() : Void {
		actual.prependIterable({iterator: filledList.productIterator}).equals([1, 2, 3, 4, 1, 2, 3, 4].toList()).isTrue();
	}

	@Test
	public function when_calling_prependIterator__should_not_be_null() : Void {
		actual.prependIterator(filledList.productIterator()).isNotNull();
	}

	@Test
	public function when_calling_prependIterator__should_be_size_8() : Void {
		actual.prependIterator(filledList.productIterator()).size.areEqual(8);
	}

	@Test
	public function when_calling_prependIterator__should_be_1_2_3_4_1_2_3_4() : Void {
		actual.prependIterator(filledList.productIterator()).equals([1, 2, 3, 4, 1, 2, 3, 4].toList()).isTrue();
	}

	@Test
	public function when_calling_prependAll__should_not_be_null() : Void {
		actual.prependAll(filledList).isNotNull();
	}

	@Test
	public function when_calling_prependAll__should_be_1_2_3_4_1_2_3_4() : Void {
		actual.prependAll(filledList).equals([1, 2, 3, 4, 1, 2, 3, 4].toList()).isTrue();
	}

	@Test
	public function when_calling_toString_should_return_List() : Void {
		actual.toString().areEqual(Std.format('$listClassName(1, 2, 3, 4)'));
	}

	@Test
	public function when_calling_productPrefix_on_list_should_return_List() : Void {
		actual.productPrefix.areEqual(Std.format('$listClassName'));
	}

	@Test
	public function when_calling_productIterator_on_list_is_not_null() : Void {
		actual.productIterator().isNotNull();
	}

	@Test
	public function when_calling_productIterator_on_list_should_hasNext_be_true() : Void {
		actual.productIterator().hasNext().isTrue();
	}

	@Test
	public function when_calling_productIterator_on_list_should_next_be_1() : Void {
		actual.productIterator().next().areEqual(1);
	}

	@Test
	public function when_calling_productIterator_on_list_should_next_be_2() : Void {
		var iterator = actual.productIterator();
		iterator.next();
		iterator.next().areEqual(2);
	}

	@Test
	public function when_calling_productIterator_on_list_should_next_be_3() : Void {
		var iterator = actual.productIterator();
		iterator.next();
		iterator.next();
		iterator.next().areEqual(3);
	}

	@Test
	public function when_calling_productIterator_on_list_should_next_be_4() : Void {
		var iterator = actual.productIterator();
		iterator.next();
		iterator.next();
		iterator.next();
		iterator.next().areEqual(4);
	}

	@Test
	public function when_calling_productIterator_on_list_should_throw_error_when_iterator_is_exhausted() : Void {
		var iterator = actual.productIterator();
		iterator.next();
		iterator.next();
		iterator.next();
		iterator.next();

		var called = try {
			iterator.next();
			false;
		} catch (error : NoSuchElementError) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function when_calling_productIterator_on_list_should_nextOption_be_1() : Void {
		var iterator : ListIterator<Int> = cast actual.productIterator();
		iterator.nextOption().get().areEqual(1);
	}

	@Test
	public function when_calling_productIterator_on_list_should_nextOption_be_2() : Void {
		var iterator : ListIterator<Int> = cast actual.productIterator();
		iterator.next();
		iterator.nextOption().get().areEqual(2);
	}

	@Test
	public function when_calling_productIterator_on_list_should_nextOption_be_3() : Void {
		var iterator : ListIterator<Int> = cast actual.productIterator();
		iterator.next();
		iterator.next();
		iterator.nextOption().get().areEqual(3);
	}

	@Test
	public function when_calling_productIterator_on_list_should_nextOption_be_4() : Void {
		var iterator : ListIterator<Int> = cast actual.productIterator();
		iterator.next();
		iterator.next();
		iterator.next();
		iterator.nextOption().get().areEqual(4);
	}

	@Test
	public function when_calling_productIterator_on_list_should_return_Option() : Void {
		var iterator : ListIterator<Int> = cast actual.productIterator();
		iterator.next();
		iterator.next();
		iterator.next();
		iterator.next();

		iterator.nextOption().isType(IOption);
	}

	@Test
	public function when_calling_productIterator_on_list_should_return_None() : Void {
		var iterator : ListIterator<Int> = cast actual.productIterator();
		iterator.next();
		iterator.next();
		iterator.next();
		iterator.next();

		iterator.nextOption().isEmpty().isTrue();
	}
}
