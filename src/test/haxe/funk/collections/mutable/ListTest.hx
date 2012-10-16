package funk.collections.mutable;

import funk.collections.ListTestBase;
import funk.collections.mutable.ListUtil;
import funk.collections.mutable.Nil;

using funk.collections.mutable.ListUtil;
using funk.collections.mutable.Nil;

class ListTest extends ListTestBase {

	@Before
	public function setup():Void {
		actual = [1, 2, 3, 4].toList();
		expected = [1, 2, 3, 4].toList();
		other = Nil.list();
		filledList = [1, 2, 3, 4].toList();
	}

	@After
	public function tearDown():Void {
		actual = null;
		expected = null;
		other = null;
	}
}
