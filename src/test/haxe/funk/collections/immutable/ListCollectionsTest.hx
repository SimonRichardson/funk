package funk.collections.immutable;

import funk.collections.CollectionsTestBase;
import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;
import funk.collections.immutable.extensions.ListsUtil;

using funk.collections.immutable.List;
using funk.collections.immutable.extensions.Lists;
using funk.collections.immutable.extensions.ListsUtil;

class ListCollectionsTest extends CollectionsTestBase {

	@Before
	public function setup() : Void {
		alpha = 'abcde'.toList().collection();

		actual = [1, 2, 3, 4, 5].toList().collection();
		actualTotal = 5;

		var stack = Nil;
		stack = Lists.prepend(stack, [1, 2, 3].toList().collection());
		stack = Lists.prepend(stack, [4, 5].toList().collection());
		stack = Lists.prepend(stack, [6].toList().collection());
		stack = Lists.prepend(stack, [7, 8, 9].toList().collection());
		stack = Lists.reverse(stack);
		complex = stack.collection();

		other = [6, 7, 8, 9].toList().collection();
		otherTotal = 4;

		empty = Nil.collection();
		emptyTotal = 0;

		name = 'Collection';
		emptyName = 'Collection';
	}

}
