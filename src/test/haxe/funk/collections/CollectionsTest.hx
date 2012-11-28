package funk.collections;

import funk.collections.CollectionsTestBase;

class CollectionsTest extends CollectionsTestBase {

	@Before
	public function setup() : Void {
		alpha = ['a', 'b', 'c', 'd', 'e'];

		actual = [1, 2, 3, 4, 5];
		actualTotal = 5;

		complex = [[1, 2, 3], [4, 5], [6], [7, 8, 9]];

		other = [6, 7, 8, 9];
		otherTotal = 4;
	}

}
