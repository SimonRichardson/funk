package funk.collections;

import funk.collections.IList;
import funk.errors.ArgumentError;
import funk.errors.RangeError;
import funk.option.Option;
import funk.unit.Expect;
import funk.wildcard.Wildcard;
import unit.ExpectUtil;
import unit.Should;

using funk.unit.Expect;
using funk.option.Option;
using funk.wildcard.Wildcard;
using unit.ExpectUtil;
using unit.Should;

class NilTestBase {
	
	public var actual : IList<Dynamic>;
	
	public var expected : IList<Dynamic>;
	
	public var other : IList<Dynamic>;
	
	@Test
	public function should_not_be_not_empty():Void {
		should("not be not empty").expect(actual.nonEmpty).toBeFalsy();
	}
	
	@Test
	public function should_be_empty():Void {
		should("be empty").expect(actual.isEmpty).toBeTruthy();
	}
	
	@Test
	public function should_have_zero_size():Void {
		should("have zero size").expect(actual.size).toStrictlyEqual(0);
	}
	
	@Test
	public function should_have_a_defined_size():Void {
		should("have a defined size").expect(actual.hasDefinedSize).toBeTruthy();
	}
	
	@Test
	public function should_not_call_count() : Void {
		should("not call count").expect(actual.count(function(x : Int) : Bool {
			should("not be called").fail();
			return false;
		}));
	}
	
	@Test
	public function when_drop_on_nil__return_nil_when_calling_drop() : Void {
		should("return nil when calling drop").expect(actual.drop(0)).toBeEqualTo(expected);
	}
	
	@Test
	@Expect("funk.errors.ArgumentError")
	public function when_drop_on_nil__throw_argument_when_passing_minus_to_drop() : Void {
		try {
			actual.drop(-1);
		} catch(e : Dynamic) {
			should("throw argument error when passing -1 to drop").expect(Std.is(e, ArgumentError)).toBeTruthy();
		}
	}
	
	@Test
	public function when_drop_on_nil__return_nil_when_calling_dropRight() : Void {
		should("return nil when calling dropRight").expect(actual.dropRight(0)).toBeEqualTo(expected);
	}
	
	@Test
	public function when_drop_on_nil__throw_argument_when_passing_minus_to_dropRight() : Void {
		try {
			actual.dropRight(-1);
		} catch(e : Dynamic) {
			should("throw argument error when passing -1 to dropRight").expect(Std.is(e, ArgumentError)).toBeTruthy();
		}
	}
	
	@Test
	public function when_drop_on_nil__return_nil_when_calling_dropWhile() : Void {
		should("return nil when calling dropWhile").expect(actual.dropWhile(function(x : Dynamic):Bool {
			return true;
		})).toBeEqualTo(expected);
	}
	
	@Test
	public function when_drop_on_nil__should_not_call_dropWhile() : Void {
		should("return nil when calling dropWhile").expect(actual.dropWhile(function(x : Dynamic):Bool {
			should("not be called").fail();
			return false;
		})).toBeEqualTo(expected);
	}
	
	@Test
	public function when_exists_on_nil__should_return_false_when_calling_mapTrue() : Void {
		should("return false when calling mapTrue on exists").expect(actual.exists(function(x : Dynamic):Bool {
			return true;
		})).toBeFalsy();
	}
	
	@Test
	public function when_exists_on_nil__should_not_call_exists() : Void {
		should("return false when calling mapTrue on exists").expect(actual.exists(function(x : Dynamic):Bool {
			should("not be called").fail();
			return false;
		})).toBeFalsy();
	}
	
	@Test
	public function when_filter_on_nil__should_return_list_when_calling_mapFalse() : Void {
		should("return nil when calling mapFalse on filter").expect(actual.filter(function(x : Dynamic):Bool {
			return false;
		})).toBeEqualTo(expected);
	}
	
	@Test
	public function when_filter_on_nil__should_not_call_filter() : Void {
		should("not throw an error when calling filter on nil").expect(actual.filter(function(x : Dynamic):Bool {
			should("not be called").fail();
			return false;
		})).toBeEqualTo(expected);
	}
	
	@Test
	public function when_filterNot_on_nil__should_return_list_when_calling_mapFalse() : Void {
		should("return nil when calling mapFalse on filterNot").expect(actual.filterNot(function(x : Dynamic):Bool {
			return false;
		})).toBeEqualTo(expected);
	}
	
	@Test
	public function when_filterNot_on_nil__should_not_throw_error() : Void {
		should("not throw an error when calling filterNot on nil").expect(actual.filterNot(function(x : Dynamic):Bool {
			should("not be called").fail();
			return false;
		})).toBeEqualTo(expected);
	}
	
	@Test
	public function when_find_on_nil__should_return_None_when_calling_mapFalse() : Void {
		should("return nil when calling mapFalse on find").expect(actual.find(function(x : Dynamic):Bool {
			return false;
		})).toBeEqualTo(None);
	}
	
	@Test
	public function when_find_on_nil__should_not_call_find() : Void {
		should("not throw an error when calling find on nil").expect(actual.find(function(x : Dynamic):Bool {
			should("not be called").fail();
			return false;
		})).toBeEqualTo(None);
	}
	
	@Test
	public function when_findIndexOf_on_nil__should_return_minus_1_when_calling_mapTrue() : Void {
		should("return nil when calling mapTrue on findIndexOf").expect(actual.findIndexOf(function(x : Dynamic):Bool {
			return true;
		})).toBeEqualTo(-1);
	}
	
	@Test
	public function when_IndexOf_on_nil__should_return_minus_1_when_finding_null() : Void {
		should("return nil when calling null on indexOf").expect(actual.indexOf(null)).toBeEqualTo(-1);
	}
	
	@Test
	public function when_IndexOf_on_nil__should_return_minus_1_when_finding_true() : Void {
		should("return nil when calling true on indexOf").expect(actual.indexOf(true)).toBeEqualTo(-1);
	}
	
	@Test
	public function when_IndexOf_on_nil__should_return_minus_1_when_finding_false() : Void {
		should("return nil when calling false on indexOf").expect(actual.indexOf(false)).toBeEqualTo(-1);
	}
	
	@Test
	public function when_IndexOf_on_nil__should_return_minus_1_when_finding_array() : Void {
		should("return nil when calling [] on indexOf").expect(actual.indexOf([])).toBeEqualTo(-1);
	}
	
	@Test
	public function when_zip_on_nil__should_not_be_null() : Void {
		should("zip be not null").expect(actual.zip(other)).toBeNotNull();
	}
	
	@Test
	public function when_zip_on_nil__should_be_equal_to_nil() : Void {
		should("zip be nil").expect(actual.zip(other)).toBeEqualTo(expected);
	}
	
	@Test
	public function when_zip_on_nil__should_be_equal_to_nil_even_if_other_is_not_empty() : Void {
		should("zip be nil even if other not empty").expect(actual.zip(other.prepend(1))).toBeEqualTo(expected);
	}
	
	@Test
	public function when_find_on_nil__should_not_call_findIndexOf() : Void {
		should("not throw an error when calling findIndexOf on nil").expect(actual.findIndexOf(function(x : Dynamic):Bool {
			should("not be called").fail();
			return false;
		})).toBeEqualTo(-1);
	}
	
	@Test
	public function when_flatMap_on_nil__should_return_list_when_calling_indentity() : Void {
		should("return nil when calling indentity on findIndexOf").expect(actual.flatMap(function(x : Dynamic):IList<Dynamic> {
			return other;
		})).toBeEqualTo(expected);
	}
	
	@Test
	public function when_find_on_nil__should_not_call_flatMap() : Void {
		should("not throw an error when calling flatMap on nil").expect(actual.flatMap(function(x : Dynamic):IList<Dynamic> {
			should("not be called").fail();
			return other;
		})).toBeEqualTo(expected);
	}
	
	@Test
	public function when_flatten_on_nil__should_return_list() : Void {
		should("return nil when calling flatten").expect(actual.flatten).toBeEqualTo(expected);
	}
	
	@Test
	public function when_fold_on_nil__should_foldLeft_should_return_0() : Void {
		should("return 0 when calling foldLeft").expect(actual.foldLeft(0, _.plus_)).toBeEqualTo(0);
	}
	
	@Test
	public function when_fold_on_nil__should_not_call_foldLeft() : Void {
		should("return 0 when calling foldLeft").expect(actual.foldLeft(0, function(x:Int, y:Int):Int {
			should("not be called").fail();
			return 0;
		})).toBeEqualTo(0);
	}
	
	@Test
	public function when_fold_on_nil__should_foldRight_should_return_0() : Void {
		should("return 0 when calling foldRight").expect(actual.foldRight(0, _.plus_)).toBeEqualTo(0);
	}
	
	@Test
	public function when_fold_on_nil__should_not_call_foldRight() : Void {
		should("return 0 when calling foldRight").expect(actual.foldRight(0, function(x:Int, y:Int):Int {
			should("not be called").fail();
			return 0;
		})).toBeEqualTo(0);
	}

	@Test
	public function when_take_on_nil__should_not_return_null() : Void {
		should("calling take should not return null").expect(actual.take(0)).toBeNotNull();
	}
	
	@Test
	public function when_take_on_nil__should_return_nil_list() : Void {
		should("return nil when calling take").expect(actual.take(0)).toBeEqualTo(expected);
	}
	
	@Test
	public function when_take_on_nil__should_return_nil_list_with_1() : Void {
		should("return nil when calling take with 1").expect(actual.take(1)).toBeEqualTo(expected);
	}
	
	@Test
	public function when_takeRight_on_nil__should_not_return_null() : Void {
		should("calling takeRight should not return null").expect(actual.takeRight(0)).toBeNotNull();
	}
	
	@Test
	public function when_takeRight_on_nil__should_return_nil_list() : Void {
		should("return nil when calling takeRight").expect(actual.takeRight(0)).toBeEqualTo(expected);
	}
	
	@Test
	public function when_takeRight_on_nil__should_return_nil_list_with_1() : Void {
		should("return nil when calling takeRight").expect(actual.takeRight(1)).toBeEqualTo(expected);
	}

	@Test
	public function when_contains_on_nil__should_not_contain_null() : Void {
		should("not contain null").expect(actual.contains(null)).toBeFalsy();
	}
	
	@Test
	public function when_contains_on_nil__should_not_contain_true() : Void {
		should("not contain true").expect(actual.contains(true)).toBeFalsy();
	}
	
	@Test
	public function when_contains_on_nil__should_not_contain_object() : Void {
		should("not contain {}").expect(actual.contains({})).toBeFalsy();
	}
	
	@Test
	public function when_contains_on_nil__should_not_contain_array() : Void {
		should("not contain []").expect(actual.contains([])).toBeFalsy();
	}
	
	@Test
	public function when_toArray_on_nil__should_not_be_null() : Void {
		should("not be null").expect(actual.toArray).toBeNotNull();
	}
	
	@Test
	public function when_toArray_on_nil__should_be_length_0() : Void {
		should("not be 0").expect(actual.toArray.length).toBeEqualTo(0);
	}
	
	@Test
	public function when_head_on_nil__should_be_null() : Void {
		should("head be null").expect(actual.head).toBeNull();
	}
	
	@Test
	public function when_headOption_on_nil__should_be_None() : Void {
		should("headOption be None").expect(actual.headOption).toBeEqualTo(None);
	}
	
	@Test
	public function when_indices_on_nil__should_not_be_null() : Void {
		should("indices be not null").expect(actual.indices).toBeNotNull();
	}
	
	@Test
	public function when_indices_on_nil__should_be_equal_to_nil() : Void {
		should("indices be nil").expect(actual.indices).toBeEqualTo(expected);
	}
	
	@Test
	public function when_init_on_nil__should_not_be_null() : Void {
		should("init be not null").expect(actual.init).toBeNotNull();
	}
	
	@Test
	public function when_init_on_nil__should_be_equal_to_nil() : Void {
		should("init be nil").expect(actual.init).toBeEqualTo(expected);
	}
	
	@Test
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
	}
	
}
