package funk.collections.immutable;

import funk.collections.immutable.Nil;
import funk.unit.Expect;
import unit.ExpectUtil;
import unit.Should;

using funk.collections.immutable.Nil;
using funk.unit.Expect;
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
}