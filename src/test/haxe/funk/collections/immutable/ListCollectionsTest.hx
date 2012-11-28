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
		alpha = 'abcde'.toList().iterable();

		actual = [1, 2, 3, 4, 5].toList().iterable();
		actualTotal = 5;

		var stack = Nil;
		stack = Lists.prepend(stack, [1, 2, 3].toList().iterable());
		stack = Lists.prepend(stack, [4, 5].toList().iterable());
		stack = Lists.prepend(stack, [6].toList().iterable());
		stack = Lists.prepend(stack, [7, 8, 9].toList().iterable());
		stack = Lists.reverse(stack);
		complex = stack.iterable();

		other = [6, 7, 8, 9].toList().iterable();
		otherTotal = 4;

		name = 'Collections';
	}

}
