package funk.collections;

import funk.collections.IMap;
import funk.errors.ArgumentError;
import funk.errors.RangeError;
import funk.option.Option;
import funk.tuple.Tuple2;
import massive.munit.Assert;
import util.AssertExtensions;

using funk.option.Option;
using funk.tuple.Tuple2;
using massive.munit.Assert;
using util.AssertExtensions;

class NilMapTestBase {

	public var actual : IMap<Dynamic, Dynamic>;

	public var expected : IMap<Dynamic, Dynamic>;

	public var other : IMap<Dynamic, Dynamic>;

	public var filledMap : IMap<Dynamic, Dynamic>;

	@Test
	public function should_not_be_not_empty():Void {
		actual.nonEmpty.isFalse();
	}

	@Test
	public function should_be_empty():Void {
		actual.isEmpty.isTrue();
	}

	@Test
	public function should_have_zero_size():Void {
		actual.size.areEqual(0);
	}

	@Test
	public function should_have_a_defined_size():Void {
		actual.hasDefinedSize.isTrue();
	}

	@Test
	public function should_not_call_count() : Void {
		actual.count(function(k, v) {
			Assert.fail("fail if called");
			return false;
		});
	}

	@Test
	public function when_drop_on_nil__return_nil_when_calling_drop() : Void {
		actual.drop(0).areEqual(expected);
	}

	@Test
	public function when_drop_on_nil__throw_argument_when_passing_minus_to_drop() : Void {
		var called = try {
			actual.drop(-1);
			false;
		} catch(error : ArgumentError) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function when_drop_on_nil__return_nil_when_calling_dropRight() : Void {
		actual.dropRight(0).areEqual(expected);
	}

	@Test
	public function when_drop_on_nil__throw_argument_when_passing_minus_to_dropRight() : Void {
		var called = try {
			actual.dropRight(-1);
			false;
		} catch(error : ArgumentError) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function when_drop_on_nil__return_nil_when_calling_dropWhile() : Void {
		actual.dropWhile(function(k : Dynamic, v : Dynamic):Bool {
			return true;
		}).areEqual(expected);
	}

	@Test
	public function when_drop_on_nil__should_not_call_dropWhile() : Void {
		actual.dropWhile(function(k : Dynamic, v : Dynamic):Bool {
			Assert.fail("fail if called");
			return false;
		}).areEqual(expected);
	}

	@Test
	public function when_exists_on_nil__should_return_false_when_calling_mapTrue() : Void {
		actual.exists(function(k : Dynamic, v : Dynamic):Bool {
			return true;
		}).isFalse();
	}

	@Test
	public function when_exists_on_nil__should_not_call_exists() : Void {
		actual.exists(function(k : Dynamic, v : Dynamic):Bool {
			Assert.fail("fail if called");
			return false;
		}).isFalse();
	}

	@Test
	public function when_filter_on_nil__should_return_list_when_calling_mapFalse() : Void {
		actual.filter(function(k : Dynamic, v : Dynamic):Bool {
			return false;
		}).areEqual(expected);
	}

	@Test
	public function when_filter_on_nil__should_not_call_filter() : Void {
		actual.filter(function(k : Dynamic, v : Dynamic):Bool {
			Assert.fail("fail if called");
			return false;
		}).areEqual(expected);
	}

	@Test
	public function when_filterNot_on_nil__should_return_list_when_calling_mapFalse() : Void {
		actual.filterNot(function(k : Dynamic, v : Dynamic):Bool {
			return false;
		}).areEqual(expected);
	}

	@Test
	public function when_filterNot_on_nil__should_not_throw_error() : Void {
		actual.filterNot(function(k : Dynamic, v : Dynamic):Bool {
			Assert.fail("fail if called");
			return false;
		}).areEqual(expected);
	}

	@Test
	public function when_find_on_nil__should_return_Option_when_calling_mapFalse() : Void {
		actual.find(function(k : Dynamic, v : Dynamic):Bool {
			return false;
		}).isType(IOption);
	}

	@Test
	public function when_find_on_nil__should_return_None_when_calling_mapFalse() : Void {
		actual.find(function(k : Dynamic, v : Dynamic):Bool {
			return false;
		}).isEmpty().isTrue();
	}

	@Test
	public function when_find_on_nil__should_not_call_find() : Void {
		actual.find(function(k : Dynamic, v : Dynamic):Bool {
			Assert.fail("fail if called");
			return false;
		}).isType(IOption);
	}

	@Test
	public function when_zip_on_nil__should_not_be_null() : Void {
		actual.zip(other).isNotNull();
	}

	@Test
	public function when_zip_on_nil__should_be_equal_to_nil() : Void {
		actual.zip(other).areEqual(expected);
	}

	@Test
	public function when_zip_on_nil__should_be_equal_to_nil_even_if_other_is_not_empty() : Void {
		actual.zip(other.add(0, 1)).areEqual(expected);
	}

	@Test
	public function when_map_on_nil__should_return_list() : Void {
		actual.map(function(tuple) : ITuple2<Float, Float> {
			return tuple2(1.1, 1.1).toInstance();
		}).isType(IMap);
	}

	@Test
	public function when_map_on_nil__should_return_empty_list() : Void {
		actual.map(function(tuple) : ITuple2<Float, Float> {
			return tuple2(1.1, 1.1).toInstance();
		}).size.areEqual(0);
	}

	@Test
	public function when_flatMap_on_nil__should_return_list_when_calling_indentity() : Void {
		actual.flatMap(function(tuple):IMap<Dynamic, Dynamic> {
			return other;
		}).areEqual(expected);
	}

	@Test
	public function when_find_on_nil__should_not_call_flatMap() : Void {
		actual.flatMap(function(tuple):IMap<Dynamic, Dynamic> {
			Assert.fail("fail if called");
			return other;
		}).areEqual(expected);
	}

	@Test
	public function when_flatten_on_nil__should_return_list() : Void {
		actual.flatten.areEqual(expected);
	}

	@Test
	public function when_fold_on_nil__should_foldLeft_should_return_0() : Void {
		//should("return 0 when calling foldLeft").expect(actual.foldLeft(0, _.plus_)).toBeEqualTo(0);
	}

	@Test
	public function when_fold_on_nil__should_not_call_foldLeft() : Void {
		var tuple = tuple2(0, 0).toInstance();
		actual.foldLeft(tuple, function(x, y) {
			Assert.fail("fail if called");
			return null;
		}).areEqual(tuple);
	}

	@Test
	public function when_fold_on_nil__should_foldRight_should_return_0() : Void {
		//should("return 0 when calling foldRight").expect(actual.foldRight(0, _.plus_)).toBeEqualTo(0);
	}

	@Test
	public function when_fold_on_nil__should_not_call_foldRight() : Void {
		var tuple = tuple2(0, 0).toInstance();
		actual.foldRight(tuple, function(x, y) {
			Assert.fail("fail if called");
			return null;
		}).areEqual(tuple);
	}

	@Test
	public function when_forall_on_nil__should_return_false() : Void {
		actual.forall(function(key : Dynamic, value : Dynamic) : Bool {
			return true;
		}).isFalse();
	}

	@Test
	public function when_forall_on_nil__should_not_run_function() : Void {
		actual.forall(function(key : Dynamic, value : Dynamic) : Bool {
			Assert.fail("fail if called");
			return true;
		}).isFalse();
	}

	@Test
	public function when_foreach_on_nil__should_not_run_function() : Void {
		actual.foreach(function(key : Dynamic, value : Dynamic) : Void {
			Assert.fail("fail if called");
		});
	}

	@Test
	public function when_partition__should_return_isNotNull() : Void {
		actual.partition(function(key : Dynamic, value : Dynamic) : Bool {
			return true;
		}).isNotNull();
	}

	@Test
	public function when_partition__should_return_a_ITuple2() : Void {
		actual.partition(function(key : Dynamic, value : Dynamic) : Bool {
			return true;
		}).isType(ITuple2);
	}

	@Test
	public function when_partition__should_return_a_ITuple2_and__1_is_IMap() : Void {
		actual.partition(function(key : Dynamic, value : Dynamic) : Bool {
			return true;
		})._1.isType(IMap);
	}

	@Test
	public function when_partition__should_return_a_ITuple2_and__1_is_IMap_of_size_0() : Void {
		actual.partition(function(key : Dynamic, value : Dynamic) : Bool {
			return true;
		})._1.size.areEqual(0);
	}

	@Test
	public function when_partition__should_return_a_ITuple2_and__2_is_IMap() : Void {
		actual.partition(function(key : Dynamic, value : Dynamic) : Bool {
			return true;
		})._2.isType(IMap);
	}

	@Test
	public function when_partition__should_return_a_ITuple2_and__2_is_IMap_of_size_0() : Void {
		actual.partition(function(key : Dynamic, value : Dynamic) : Bool {
			return true;
		})._2.size.areEqual(0);
	}

	@Test
	public function when_reduceRight_on_nil__should_return_Option() : Void {
		actual.reduceRight(function(x, y) {
			return null;
		}).isType(IOption);
	}

	@Test
	public function when_reduceRight_on_nil__should_return_None() : Void {
		actual.reduceRight(function(x, y) {
			return null;
		}).isEmpty().isTrue();
	}

	@Test
	public function when_reduceRight_on_nil__should_not_call_method() : Void {
		actual.reduceRight(function(x, y) {
			Assert.fail("fail if called");
			return null;
		}).isType(IOption);
	}

	@Test
	public function when_reduceLeft_on_nil__should_return_Option() : Void {
		actual.reduceLeft(function(x, y) {
			return null;
		}).isType(IOption);
	}

	@Test
	public function when_reduceLeft_on_nil__should_return_None() : Void {
		actual.reduceLeft(function(x, y) {
			return null;
		}).isType(IOption);
	}

	@Test
	public function when_take_0_on_nil__should_return_isNotNull() : Void {
		actual.take(0).isNotNull();
	}

	@Test
	public function when_take_0_on_nil__should_return_valid_IMap() : Void {
		actual.take(0).isType(IMap);
	}

	@Test
	public function when_take_0_on_nil__should_return_size_0() : Void {
		actual.take(0).size.areEqual(0);
	}

	@Test
	public function when_take_minus_1_on_nil__should_throw_error() : Void {
		var called = try {
			actual.take(-1);
			false;
		} catch(error : ArgumentError){
			true;
		}
		called.isTrue();
	}

	@Test
	public function when_takeRight_0_on_nil__should_return_isNotNull() : Void {
		actual.takeRight(0).isNotNull();
	}

	@Test
	public function when_takeRight_0_on_nil__should_return_valid_IMap() : Void {
		actual.takeRight(0).isType(IMap);
	}

	@Test
	public function when_takeRight_0_on_nil__should_return_size_0() : Void {
		actual.takeRight(0).size.areEqual(0);
	}

	@Test
	public function when_takeRight_minus_1_on_nil__should_throw_error() : Void {
		var called = try {
			actual.takeRight(-1);
			false;
		} catch(error : ArgumentError){
			true;
		}
		called.isTrue();
	}

	@Test
	public function when_takeWhile_on_nil__should_return_isNotNull() : Void {
		actual.takeWhile(function(value) : Bool {
			return true;
		}).isNotNull();
	}

	@Test
	public function when_takeWhile_on_nil__should_return_valid_IMap() : Void {
		actual.takeWhile(function(value) : Bool {
			return true;
		}).isType(IMap);
	}

	@Test
	public function when_takeWhile_on_nil__should_return_size_0() : Void {
		actual.takeWhile(function(value) : Bool {
			return true;
		}).size.areEqual(0);
	}

	@Test
	public function when_takeWhile_on_nil__should_not_call_method() : Void {
		actual.takeWhile(function(value) : Bool {
			Assert.fail("fail if called");
			return true;
		});
	}

	@Test
	public function when_get_0_on_nil__should_return_Option() : Void {
		actual.get(0).isType(IOption);
	}

	@Test
	public function when_get_0_on_nil__should_return_None() : Void {
		actual.get(0).isEmpty().isTrue();
	}

	@Test
	public function when_take_on_nil__should_not_return_null() : Void {
		actual.take(0).isNotNull();
	}

	@Test
	public function when_take_on_nil__should_return_nil_list() : Void {
		actual.take(0).areEqual(expected);
	}

	@Test
	public function when_take_on_nil__should_return_nil_list_with_1() : Void {
		actual.take(1).areEqual(expected);
	}

	@Test
	public function when_takeRight_on_nil__should_not_return_null() : Void {
		actual.takeRight(0).isNotNull();
	}

	@Test
	public function when_takeRight_on_nil__should_return_nil_list() : Void {
		actual.takeRight(0).areEqual(expected);
	}

	@Test
	public function when_takeRight_on_nil__should_return_nil_list_with_1() : Void {
		actual.takeRight(1).areEqual(expected);
	}

	@Test
	public function when_containsKey_on_nil__should_not_contain_null() : Void {
		actual.containsKey(null).isFalse();
	}

	@Test
	public function when_containsKey_on_nil__should_not_contain_true() : Void {
		actual.containsKey(true).isFalse();
	}

	@Test
	public function when_containsKey_on_nil__should_not_contain_object() : Void {
		actual.containsKey({}).isFalse();
	}

	@Test
	public function when_containsKey_on_nil__should_not_contain_array() : Void {
		actual.containsKey([]).isFalse();
	}

	@Test
	public function when_containsValue_on_nil__should_not_contain_null() : Void {
		actual.containsValue(null).isFalse();
	}

	@Test
	public function when_containsValue_on_nil__should_not_contain_true() : Void {
		actual.containsValue(true).isFalse();
	}

	@Test
	public function when_containsValue_on_nil__should_not_contain_object() : Void {
		actual.containsValue({}).isFalse();
	}

	@Test
	public function when_containsValue_on_nil__should_not_contain_array() : Void {
		actual.containsValue([]).isFalse();
	}

	@Test
	public function when_toArray_on_nil__should_not_be_null() : Void {
		actual.toArray.isNotNull();
	}

	@Test
	public function when_toArray_on_nil__should_be_length_0() : Void {
		actual.toArray.length.areEqual(0);
	}

	@Test
	public function when_zipWithIndex_on_nil__should_not_be_null() : Void {
		actual.zipWithIndex.isNotNull();
	}

	@Test
	public function when_zipWithIndex_on_nil__should_be_equal_to_nil() : Void {
		actual.zipWithIndex.areEqual(expected);
	}

	@Test
	public function when_productArity_on_nil__should_be_equal_to_0() : Void {
		actual.productArity.areEqual(0);
	}

	@Test
	public function when_calling_productElement_on_nil__should_throw_RangeError() : Void {
		var called = try {
			actual.productElement(0);
			false;
		} catch(e : RangeError) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function when_calling_add_on_nil__should_not_be_null() : Void {
		actual.add(1, 1).isNotNull();
	}

	@Test
	public function when_calling_add_on_nil__should_be_size_1() : Void {
		actual.add(1, 1).size.areEqual(1);
	}

	@Test
	public function when_calling_addIterable_on_nil__should_not_be_null() : Void {
		actual.addIterable({iterator: filledMap.productIterator}).isNotNull();
	}

	@Test
	public function when_calling_addIterable_on_nil__should_be_size_4() : Void {
		actual.addIterable({iterator: filledMap.productIterator}).size.areEqual(4);
	}

	@Test
	public function when_calling_iterator_on_nil__should_not_be_null() : Void {
		actual.addIterator(filledMap.productIterator()).isNotNull();
	}

	@Test
	public function when_calling_iterator_on_nil__should_be_size_4() : Void {
		actual.addIterator(filledMap.productIterator()).size.areEqual(4);
	}

	@Test
	public function when_calling_addAll_on_nil__should_not_be_null() : Void {
		actual.addAll(other.add(1, 1)).isNotNull();
	}

	@Test
	public function when_calling_addAll_on_nil__should_return_same_instance() : Void {
		var o = expected.add(1, 1);
		actual.addAll(o).areEqual(o);
	}

	@Test
	public function when_calling_toString_on_nil_should_return_Nil() : Void {
		actual.toString().areEqual('Nil');
	}

	@Test
	public function when_calling_productPrefix_on_nil_should_return_Nil() : Void {
		actual.productPrefix.areEqual('Nil');
	}

	@Test
	public function when_calling_productIterator_on_nil_is_not_null() : Void {
		actual.productIterator().isNotNull();
	}

	@Test
	public function when_calling_productIterator_on_nil_should_hasNext_be_false() : Void {
		actual.productIterator().hasNext().isFalse();
	}

	@Test
	public function when_head_on_nil__should_be_null() : Void {
		actual.head.isNull();
	}

	@Test
	public function when_headOption_on_nil__should_be_Option() : Void {
		actual.headOption.isType(IOption);
	}

	@Test
	public function when_headOption_on_nil__should_be_None() : Void {
		actual.headOption.isEmpty().isTrue();
	}

	@Test
	public function when_tail_on_nil__should_be_null() : Void {
		actual.tail.isNull();
	}

	@Test
	public function when_tailOption_on_nil__should_be_Option() : Void {
		actual.tailOption.isType(IOption);
	}

	@Test
	public function when_tailOption_on_nil__should_be_None() : Void {
		actual.tailOption.isEmpty().isTrue();
	}
}
