package funk.collections.immutable;

import funk.collections.ListTestBase;
import funk.collections.immutable.ListUtil;
import funk.collections.immutable.Nil;

using funk.collections.immutable.ListUtil;
using funk.collections.immutable.Nil;

class ListTest extends ListTestBase {

	@Before
	public function setup():Void {
		listClassName = 'List';

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
		filledList = null;
	}
}
