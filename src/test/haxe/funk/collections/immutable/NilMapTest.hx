package funk.collections.immutable;

import funk.collections.NilMapTestBase;
import funk.collections.immutable.MapUtil;
import funk.collections.immutable.Nil;

using funk.collections.immutable.MapUtil;
using funk.collections.immutable.Nil;

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
