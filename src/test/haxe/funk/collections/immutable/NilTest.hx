package funk.collections.immutable;

import funk.collections.immutable.Nil;
import funk.errors.ArgumentError;
import funk.option.Option;
import funk.unit.Expect;
import funk.Wildcard;
import unit.ExpectUtil;
import unit.Should;

using funk.collections.immutable.Nil;
using funk.unit.Expect;
using funk.option.Option;
using funk.Wildcard;
using unit.ExpectUtil;
using unit.Should;

/**
* Auto generated MassiveUnit Test Class  for funk.collections.immutable.Nil 
*/
class NilTest {
	
	public function new() {
		
	}
	
	@Test
	public function should_not_be_not_empty():Void {
		should("not be not empty").expect(nil.list().nonEmpty).toBeFalsy();
	}
	
	@Test
	public function should_be_empty():Void {
		should("be empty").expect(nil.list().isEmpty).toBeTruthy();
	}
	
	@Test
	public function should_have_zero_size():Void {
		should("have zero size").expect(nil.list().size).toStrictlyEqual(0);
	}
	
	@Test
	public function should_have_a_defined_size():Void {
		should("have a defined size").expect(nil.list().hasDefinedSize).toBeTruthy();
	}
	
	@Test
	public function should_not_call_count() : Void {
		should("not call count").expect(nil.list().count(function(x : Int) : Bool {
			should("not be called").fail();
			return false;
		}));
	}
	
	@Test
	public function when_drop_on_nil__return_nil_when_calling_drop() : Void {
		should("return nil when calling drop").expect(nil.list().drop(0)).toBeEqualTo(nil.list());
	}
	
	@Test
	@Expect("funk.errors.ArgumentError")
	public function when_drop_on_nil__throw_argument_when_passing_minus_to_drop() : Void {
		try {
			nil.list().drop(-1);
		} catch(e : Dynamic) {
			should("throw argument error when passing -1 to drop").expect(Std.is(e, ArgumentError)).toBeTruthy();
		}
	}
	
	@Test
	public function when_drop_on_nil__return_nil_when_calling_dropRight() : Void {
		should("return nil when calling dropRight").expect(nil.list().dropRight(0)).toBeEqualTo(nil.list());
	}
	
	@Test
	public function when_drop_on_nil__throw_argument_when_passing_minus_to_dropRight() : Void {
		try {
			nil.list().dropRight(-1);
		} catch(e : Dynamic) {
			should("throw argument error when passing -1 to dropRight").expect(Std.is(e, ArgumentError)).toBeTruthy();
		}
	}
	
	@Test
	public function when_drop_on_nil__return_nil_when_calling_dropWhile() : Void {
		should("return nil when calling dropWhile").expect(nil.list().dropWhile(function(x : Dynamic):Bool {
			return true;
		})).toBeEqualTo(nil.list());
	}
	
	@Test
	public function when_drop_on_nil__should_not_call_dropWhile() : Void {
		should("return nil when calling dropWhile").expect(nil.list().dropWhile(function(x : Dynamic):Bool {
			should("not be called").fail();
			return false;
		})).toBeEqualTo(nil.list());
	}
	
	@Test
	public function when_exists_on_nil__should_return_false_when_calling_mapTrue() : Void {
		should("return false when calling mapTrue on exists").expect(nil.list().exists(function(x : Dynamic):Bool {
			return true;
		})).toBeFalsy();
	}
	
	@Test
	public function when_exists_on_nil__should_not_call_exists() : Void {
		should("return false when calling mapTrue on exists").expect(nil.list().exists(function(x : Dynamic):Bool {
			should("not be called").fail();
			return false;
		})).toBeFalsy();
	}
	
	@Test
	public function when_filter_on_nil__should_return_list_when_calling_mapFalse() : Void {
		should("return nil when calling mapFalse on filter").expect(nil.list().filter(function(x : Dynamic):Bool {
			return false;
		})).toBeEqualTo(nil.list());
	}
	
	@Test
	public function when_filter_on_nil__should_not_call_filter() : Void {
		should("not throw an error when calling filter on nil").expect(nil.list().filter(function(x : Dynamic):Bool {
			should("not be called").fail();
			return false;
		})).toBeEqualTo(nil.list());
	}
	
	@Test
	public function when_filterNot_on_nil__should_return_list_when_calling_mapFalse() : Void {
		should("return nil when calling mapFalse on filterNot").expect(nil.list().filterNot(function(x : Dynamic):Bool {
			return false;
		})).toBeEqualTo(nil.list());
	}
	
	@Test
	public function when_filterNot_on_nil__should_not_throw_error() : Void {
		should("not throw an error when calling filterNot on nil").expect(nil.list().filterNot(function(x : Dynamic):Bool {
			should("not be called").fail();
			return false;
		})).toBeEqualTo(nil.list());
	}
	
	@Test
	public function when_find_on_nil__should_return_None_when_calling_mapFalse() : Void {
		should("return nil when calling mapFalse on find").expect(nil.list().find(function(x : Dynamic):Bool {
			return false;
		})).toBeEqualTo(None);
	}
	
	@Test
	public function when_find_on_nil__should_not_call_find() : Void {
		should("not throw an error when calling find on nil").expect(nil.list().find(function(x : Dynamic):Bool {
			should("not be called").fail();
			return false;
		})).toBeEqualTo(None);
	}
	
	@Test
	public function when_findIndexOf_on_nil__should_return_minus_1_when_calling_mapTrue() : Void {
		should("return nil when calling mapTrue on findIndexOf").expect(nil.list().findIndexOf(function(x : Dynamic):Bool {
			return true;
		})).toBeEqualTo(-1);
	}
	
	@Test
	public function when_find_on_nil__should_not_call_findIndexOf() : Void {
		should("not throw an error when calling findIndexOf on nil").expect(nil.list().findIndexOf(function(x : Dynamic):Bool {
			should("not be called").fail();
			return false;
		})).toBeEqualTo(-1);
	}
	
	@Test
	public function when_flatMap_on_nil__should_return_list_when_calling_indentity() : Void {
		should("return nil when calling indentity on findIndexOf").expect(nil.list().flatMap(function(x : Dynamic):IList<Dynamic> {
			return nil.list();
		})).toBeEqualTo(nil.list());
	}
	
	@Test
	public function when_find_on_nil__should_not_call_flatMap() : Void {
		should("not throw an error when calling flatMap on nil").expect(nil.list().flatMap(function(x : Dynamic):IList<Dynamic> {
			should("not be called").fail();
			return nil.list();
		})).toBeEqualTo(nil.list());
	}
	
	@Test
	public function when_flatten_on_nil__should_return_list() : Void {
		should("return nil when calling flatten").expect(nil.list().flatten).toBeEqualTo(nil.list());
	}
	
	@Test
	public function when_fold_on_nil__should_foldLeft_should_return_0() : Void {
		should("return 0 when calling foldLeft").expect(nil.list().foldLeft(0, _.plus_)).toBeEqualTo(0);
	}
	
	@Test
	public function when_fold_on_nil__should_not_call_foldLeft() : Void {
		should("return 0 when calling foldLeft").expect(nil.list().foldLeft(0, function(x:Int, y:Int):Int {
			should("not be called").fail();
			return 0;
		})).toBeEqualTo(0);
	}
	
	@Test
	public function when_fold_on_nil__should_foldRight_should_return_0() : Void {
		should("return 0 when calling foldRight").expect(nil.list().foldRight(0, _.plus_)).toBeEqualTo(0);
	}
	
	@Test
	public function when_fold_on_nil__should_not_call_foldRight() : Void {
		should("return 0 when calling foldRight").expect(nil.list().foldRight(0, function(x:Int, y:Int):Int {
			should("not be called").fail();
			return 0;
		})).toBeEqualTo(0);
	}
	
	@Test
	public function when_contains_on_nil__should_not_contain_null() : Void {
		should("not contain null").expect(nil.list().contains(null)).toBeFalsy();
	}
	
	@Test
	public function when_contains_on_nil__should_not_contain_true() : Void {
		should("not contain true").expect(nil.list().contains(true)).toBeFalsy();
	}
	
	@Test
	public function when_contains_on_nil__should_not_contain_object() : Void {
		should("not contain {}").expect(nil.list().contains({})).toBeFalsy();
	}
	
	@Test
	public function when_contains_on_nil__should_not_contain_array() : Void {
		should("not contain []").expect(nil.list().contains([])).toBeFalsy();
	}
	
	@Test
	public function when_toArray_on_nil__should_not_be_null() : Void {
		should("not be null").expect(nil.list().toArray).toBeNotNull();
	}
	
	@Test
	public function when_toArray_on_nil__should_be_length_0() : Void {
		should("not be 0").expect(nil.list().toArray.length).toBeEqualTo(0);
	}
	
	@Test
	public function when_head_on_nil__should_be_null() : Void {
		should("head be null").expect(nil.list().head).toBeNull();
	}
	
	@Test
	public function when_headOption_on_nil__should_be_None() : Void {
		should("headOption be None").expect(nil.list().headOption).toBeEqualTo(None);
	}
	
	@Test
	public function when_indices_on_nil__should_not_be_null() : Void {
		should("indices be not null").expect(nil.list().indices).toBeNotNull();
	}
	
	@Test
	public function when_indices_on_nil__should_be_equal_to_nil() : Void {
		should("indices be nil").expect(nil.list().indices).toBeEqualTo(nil.list());
	}
	
	@Test
	public function when_init_on_nil__should_not_be_null() : Void {
		should("init be not null").expect(nil.list().init).toBeNotNull();
	}
	
	@Test
	public function when_init_on_nil__should_be_equal_to_nil() : Void {
		should("init be nil").expect(nil.list().init).toBeEqualTo(nil.list());
	}
	
	@Test
	public function when_last_on_nil__should_not_be_null() : Void {
		should("last be not null").expect(nil.list().last).toBeNotNull();
	}
	
	@Test
	public function when_last_on_nil__should_be_equal_to_nil() : Void {
		should("last be None").expect(nil.list().last).toBeEqualTo(None);
	}
	
	@Test
	public function when_reverse_on_nil__should_not_be_null() : Void {
		should("reverse be not null").expect(nil.list().reverse).toBeNotNull();
	}
	
	@Test
	public function when_reverse_on_nil__should_be_equal_to_nil() : Void {
		should("reverse be nil").expect(nil.list().reverse).toBeEqualTo(nil.list());
	}
	
	@Test
	public function when_tail_on_nil__should_be_null() : Void {
		should("tail be null").expect(nil.list().tail).toBeNull();
	}
	
	@Test
	public function when_tailOption_on_nil__should_be_None() : Void {
		should("tailOption be None").expect(nil.list().tailOption).toBeEqualTo(None);
	}
	
	@Test
	public function when_zipWithIndex_on_nil__should_not_be_null() : Void {
		should("zipWithIndex be not null").expect(nil.list().zipWithIndex).toBeNotNull();
	}
	
	@Test
	public function when_zipWithIndex_on_nil__should_be_equal_to_nil() : Void {
		should("zipWithIndex be nil").expect(nil.list().zipWithIndex).toBeEqualTo(nil.list());
	}
}