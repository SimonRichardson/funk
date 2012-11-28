package funk.collections.immutable;

import funk.collections.immutable.ListTestBase;
import funk.collections.immutable.extensions.Lists;
import funk.collections.immutable.extensions.ListsUtil;

using funk.collections.immutable.extensions.ListsUtil;

class ListTest extends ListTestBase {

	@Before
	public function setup() : Void {
		alpha = 'abcde'.toList();

		actual = [1, 2, 3, 4, 5].toList();
		actualTotal = 5;

		complex = Nil;
		complex = Lists.prepend(complex, [1, 2, 3].toList());
		complex = Lists.prepend(complex, [4, 5].toList());
		complex = Lists.prepend(complex, [6].toList());
		complex = Lists.prepend(complex, [7, 8, 9].toList());
		complex = Lists.reverse(complex);

		other = [6, 7, 8, 9].toList();
		otherTotal = 4;

		name = 'List';
	}

}
