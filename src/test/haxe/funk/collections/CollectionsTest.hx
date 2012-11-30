package funk.collections;

import funk.collections.CollectionsTestBase;
import funk.collections.extensions.CollectionsUtil;

using funk.collections.extensions.CollectionsUtil;

class CollectionsTest extends CollectionsTestBase {

	@Before
	public function setup() : Void {
		alpha = ['a', 'b', 'c', 'd', 'e'].toCollection();

		actual = [1, 2, 3, 4, 5].toCollection();
		actualTotal = 5;

		complex = [
					[1, 2, 3].toCollection(),
					[4, 5].toCollection(),
					[6].toCollection(),
					[7, 8, 9].toCollection()
					].toCollection();

		other = [6, 7, 8, 9].toCollection();
		otherTotal = 4;

		empty = CollectionsUtil.zero();
		emptyTotal = 0;

		name = 'Collection';
		emptyName = 'Collection';
	}

}
