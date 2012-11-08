package funk.collections.immutable;

import funk.collections.NilTestBase;
import funk.collections.immutable.ListUtil;
import funk.collections.immutable.Nil;

using funk.collections.immutable.ListUtil;
using funk.collections.immutable.Nil;

class NilTest extends NilTestBase {

	@Before
	public function setup():Void {
		actual = Nil.list();
		expected = Nil.list();
		other = Nil.list();
		filledList = [1, 2, 3, 4].toList();
	}

	@After
	public function tearDown():Void {
		actual = null;
		expected = null;
		other = null;
		filledList = null;
	}
}
