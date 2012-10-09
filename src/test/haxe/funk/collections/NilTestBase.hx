package funk.collections;

import funk.collections.IList;
import funk.errors.ArgumentError;
import funk.errors.RangeError;
import funk.option.Option;
import massive.munit.Assert;
import massive.munit.AssertExtensions;

using funk.option.Option;
using massive.munit.Assert;
using massive.munit.AssertExtensions;

class NilTestBase {

	public var actual : IList<Dynamic>;

	public var expected : IList<Dynamic>;

	public var other : IList<Dynamic>;

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
		actual.count(function(x) {
			Assert.fail("fail if called");
			return false;
		});
	}

	@Test
	public function when_drop_on_nil__return_nil_when_calling_drop() : Void {
		actual.drop(0).areEqual(expected);
	}

	@Test
	@Expect("funk.errors.ArgumentError")
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
		actual.dropWhile(function(x : Dynamic):Bool {
			return true;
		}).areEqual(expected);
	}

	@Test
	public function when_drop_on_nil__should_not_call_dropWhile() : Void {
		actual.dropWhile(function(x : Dynamic):Bool {
			Assert.fail("fail if called");
			return false;
		}).areEqual(expected);
	}

	@Test
	public function when_exists_on_nil__should_return_false_when_calling_mapTrue() : Void {
		actual.exists(function(x : Dynamic):Bool {
			return true;
		}).isFalse();
	}

	@Test
	public function when_exists_on_nil__should_not_call_exists() : Void {
		actual.exists(function(x : Dynamic):Bool {
			Assert.fail("fail if called");
			return false;
		}).isFalse();
	}

	@Test
	public function when_filter_on_nil__should_return_list_when_calling_mapFalse() : Void {
		actual.filter(function(x : Dynamic):Bool {
			return false;
		}).areEqual(expected);
	}

	@Test
	public function when_filter_on_nil__should_not_call_filter() : Void {
		actual.filter(function(x : Dynamic):Bool {
			Assert.fail("fail if called");
			return false;
		}).areEqual(expected);
	}

	@Test
	public function when_filterNot_on_nil__should_return_list_when_calling_mapFalse() : Void {
		actual.filterNot(function(x : Dynamic):Bool {
			return false;
		}).areEqual(expected);
	}

	@Test
	public function when_filterNot_on_nil__should_not_throw_error() : Void {
		actual.filterNot(function(x : Dynamic):Bool {
			Assert.fail("fail if called");
			return false;
		}).areEqual(expected);
	}

	@Test
	public function when_find_on_nil__should_return_Option_when_calling_mapFalse() : Void {
		actual.find(function(x : Dynamic):Bool {
			return false;
		}).isEnum(Option);
	}

	@Test
	public function when_find_on_nil__should_return_None_when_calling_mapFalse() : Void {
		actual.find(function(x : Dynamic):Bool {
			return false;
		}).isEmpty().isTrue();
	}

	@Test
	public function when_find_on_nil__should_not_call_find() : Void {
		actual.find(function(x : Dynamic):Bool {
			Assert.fail("fail if called");
			return false;
		}).isEnum(Option);
	}

	@Test
	public function when_findIndexOf_on_nil__should_return_minus_1_when_calling_mapTrue() : Void {
		actual.findIndexOf(function(x : Dynamic):Bool {
			return true;
		}).areEqual(-1);
	}

	@Test
	public function when_IndexOf_on_nil__should_return_minus_1_when_finding_null() : Void {
		actual.indexOf(null).areEqual(-1);
	}

	@Test
	public function when_IndexOf_on_nil__should_return_minus_1_when_finding_true() : Void {
		actual.indexOf(true).areEqual(-1);
	}

	@Test
	public function when_IndexOf_on_nil__should_return_minus_1_when_finding_false() : Void {
		actual.indexOf(false).areEqual(-1);
	}

	@Test
	public function when_IndexOf_on_nil__should_return_minus_1_when_finding_array() : Void {
		actual.indexOf([]).areEqual(-1);
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
		actual.zip(other.prepend(1)).areEqual(expected);
	}

	@Test
	public function when_find_on_nil__should_not_call_findIndexOf() : Void {
		actual.findIndexOf(function(x : Dynamic):Bool {
			Assert.fail("fail if called");
			return false;
		}).areEqual(-1);
	}

	@Test
	public function when_flatMap_on_nil__should_return_list_when_calling_indentity() : Void {
		actual.flatMap(function(x : Dynamic):IList<Dynamic> {
			return other;
		}).areEqual(expected);
	}

	@Test
	public function when_find_on_nil__should_not_call_flatMap() : Void {
		actual.flatMap(function(x : Dynamic):IList<Dynamic> {
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
		actual.foldLeft(0, function(x:Int, y:Int):Int {
			Assert.fail("fail if called");
			return 0;
		}).areEqual(0);
	}

	@Test
	public function when_fold_on_nil__should_foldRight_should_return_0() : Void {
		//should("return 0 when calling foldRight").expect(actual.foldRight(0, _.plus_)).toBeEqualTo(0);
	}

	@Test
	public function when_fold_on_nil__should_not_call_foldRight() : Void {
		actual.foldRight(0, function(x:Int, y:Int):Int {
			Assert.fail("fail if called");
			return 0;
		}).areEqual(0);
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
	public function when_contains_on_nil__should_not_contain_null() : Void {
		actual.contains(null).isFalse();
	}

	@Test
	public function when_contains_on_nil__should_not_contain_true() : Void {
		actual.contains(true).isFalse();
	}

	@Test
	public function when_contains_on_nil__should_not_contain_object() : Void {
		actual.contains({}).isFalse();
	}

	@Test
	public function when_contains_on_nil__should_not_contain_array() : Void {
		actual.contains([]).isFalse();
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
	public function when_head_on_nil__should_be_null() : Void {
		actual.head.isNull();
	}

	@Test
	public function when_headOption_on_nil__should_be_Option() : Void {
		actual.headOption.isEnum(Option);
	}

	@Test
	public function when_headOption_on_nil__should_be_None() : Void {
		actual.headOption.isEmpty().isTrue();
	}

	@Test
	public function when_indices_on_nil__should_not_be_null() : Void {
		actual.indices.isNotNull();
	}

	@Test
	public function when_indices_on_nil__should_be_equal_to_nil() : Void {
		actual.indices.areEqual(expected);
	}

	@Test
	public function when_init_on_nil__should_not_be_null() : Void {
		actual.init.isNotNull();
	}

	@Test
	public function when_init_on_nil__should_be_equal_to_nil() : Void {
		actual.init.areEqual(expected);
	}

	/*@Test
	public function when_last_on_nil__should_not_be_null() : Void {
		should("last be not null").expect(actual.last).toBeNotNull();
	}

	@Test
	public function when_last_on_nil__should_be_equal_to_nil() : Void {
		should("last be None").expect(actual.last).toBeEqualTo(None);
	}

	@Test
	public function when_reverse_on_nil__should_not_be_null() : Void {
		should("reverse be not null").expect(actual.reverse).toBeNotNull();
	}

	@Test
	public function when_reverse_on_nil__should_be_equal_to_nil() : Void {
		should("reverse be nil").expect(actual.reverse).toBeEqualTo(expected);
	}

	@Test
	public function when_tail_on_nil__should_be_null() : Void {
		should("tail be null").expect(actual.tail).toBeNull();
	}

	@Test
	public function when_tailOption_on_nil__should_be_None() : Void {
		should("tailOption be None").expect(actual.tailOption).toBeEqualTo(None);
	}

	@Test
	public function when_zipWithIndex_on_nil__should_not_be_null() : Void {
		should("zipWithIndex be not null").expect(actual.zipWithIndex).toBeNotNull();
	}

	@Test
	public function when_zipWithIndex_on_nil__should_be_equal_to_nil() : Void {
		should("zipWithIndex be nil").expect(actual.zipWithIndex).toBeEqualTo(expected);
	}

	@Test
	public function when_productArity_on_nil__should_be_equal_to_0() : Void {
		should("productArity be nil").expect(actual.productArity).toBeEqualTo(0);
	}

	@Test
	public function when_calling_productElement_on_nil__should_throw_RangeError() : Void {
		try {
			actual.productElement(0);
		} catch(e : RangeError) {
			should("throw range error").expect(e).toBeOfType(RangeError);
		}
	}

	@Test
	public function when_calling_appendAll_on_nil__should_not_be_null() : Void {
		should("return same instance when calling appendAll").expect(actual.appendAll(other.prepend(1))).toBeNotNull();
	}

	@Test
	public function when_calling_appendAll_on_nil__should_return_same_instance() : Void {
		var o = expected.prepend(1);
		should("return same instance when calling appendAll").expect(actual.appendAll(o)).toBeEqualTo(o);
	}*/

}
