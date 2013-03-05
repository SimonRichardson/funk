package funk.collections.immutable;

import funk.collections.CollectionTestBase;

using funk.collections.immutable.List;
using funk.collections.immutable.ListUtil;

class ListCollectionsTest extends CollectionTestBase {

	@Before
	public function setup() : Void {
		var list : List<String> = "abcde".toList();
		alpha = list.collection();

		actual = [1, 2, 3, 4, 5].toList().collection();
		actualTotal = 5;

		var stack = Nil;
		stack = ListTypes.prepend(stack, [1, 2, 3].toList().collection());
		stack = ListTypes.prepend(stack, [4, 5].toList().collection());
		stack = ListTypes.prepend(stack, [6].toList().collection());
		stack = ListTypes.prepend(stack, [7, 8, 9].toList().collection());
		stack = ListTypes.reverse(stack);
		complex = stack.collection();

		other = [6, 7, 8, 9].toList().collection();
		otherTotal = 4;

		empty = Nil.collection();
		emptyTotal = 0;

		name = 'Collection';
		emptyName = 'Collection';
	}

}
