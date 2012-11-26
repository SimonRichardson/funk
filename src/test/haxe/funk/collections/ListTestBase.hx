package funk.collections;

import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;
import massive.munit.Assert;

using massive.munit.Assert;
using funk.collections.immutable.extensions.Lists;

class ListTestBase {

	public var actual : List<Dynamic>;

	@Test
	public function should_be_non_empty() {
		actual.nonEmpty().isTrue();
	}

	@Test
	public function should_be_empty() {
		actual.isEmpty().isFalse();
	}

	@Test
	public function when_calling_toString__should_return_valid_string() {
		actual.toString().areEqual('List(1, 2, 3, 4)');
	}
}