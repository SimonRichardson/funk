package funk.collections.immutable;

import funk.collections.immutable.Nil;
import funk.unit.Expect;
import unit.ExpectUtil;
import unit.It;

using funk.collections.immutable.Nil;
using funk.unit.Expect;
using unit.ExpectUtil;
using unit.It;

/**
* Auto generated MassiveUnit Test Class  for funk.collections.immutable.Nil 
*/
class NilTest {
	
	public function new() {
		
	}
	
	@Test
	public function should_not_be_not_empty():Void {
		it("should not be not empty").should(function() : Void {
			expect(nil.list().nonEmpty).toBeFalsy();
		});
	}
	
	@Test
	public function should_be_empty():Void {
		it("should be empty").should(function() : Void {
			expect(nil.list().isEmpty).toBeTruthy();
		});
	}
	
	@Test
	public function should_have_zero_size():Void {
		it("should have zero size").should(function() : Void {
			expect(nil.list().size).toStrictlyEqual(0);
        });
	}
	
	@Test
	public function should_have_a_defined_size():Void {
		it("should have a defined size").should(function() : Void {
			expect(nil.list().hasDefinedSize).toBeTruthy();
        });
	}
}