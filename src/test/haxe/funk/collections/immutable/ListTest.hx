package funk.collections.immutable;

import funk.collections.ListTestBase;
import funk.collections.immutable.extensions.ListsUtil;

using funk.collections.immutable.extensions.ListsUtil;

class ListTest extends ListTestBase {

	@Before
	public function setup() : Void {
		actual = [1, 2, 3, 4, 5].toList();
		actualTotal = 5;

		other = [6, 7, 8, 9].toList();
		otherTotal = 4;
	}

}
