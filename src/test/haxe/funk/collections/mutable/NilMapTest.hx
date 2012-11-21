package funk.collections.mutable;

import funk.collections.NilMapTestBase;
import funk.collections.mutable.MapUtil;
import funk.collections.mutable.Nil;

using funk.collections.mutable.MapUtil;
using funk.collections.mutable.Nil;

class NilMapTest extends NilMapTestBase {

	@Before
	public function setup():Void {
		actual = Nil.map();
		expected = Nil.map();
		other = Nil.map();
		filledMap = [1, 2, 3, 4].toMap();
	}

	@After
	public function tearDown():Void {
		actual = null;
		expected = null;
		other = null;
		filledMap = null;
	}
}
