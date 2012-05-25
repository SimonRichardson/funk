package funk.collections.mutable;

import funk.collections.NilTestBase;
import funk.collections.mutable.Nil;

using funk.collections.mutable.Nil;

/**
* Auto generated MassiveUnit Test Class  for funk.collections.mutable.Nil 
*/
class NilTest extends NilTestBase {
	
	@Before
	public function setup():Void {
		actual = nil.list();
		expected = nil.list();
		other = nil.list();
	}
	
	@After
	public function tearDown():Void {
		actual = null;
		expected = null;
		other = null;
	}
}