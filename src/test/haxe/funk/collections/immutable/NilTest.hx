package funk.collections.immutable;

import funk.collections.immutable.Nil;
import funk.errors.ArgumentError;
import funk.option.Option;
import funk.unit.Expect;
import unit.ExpectUtil;
import unit.Should;

using funk.collections.immutable.Nil;
using funk.unit.Expect;
using funk.option.Option;
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
	public function when_filter_on_nil__should_not_call_filterNot() : Void {
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
}