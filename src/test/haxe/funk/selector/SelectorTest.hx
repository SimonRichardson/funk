package funk.selector;

using massive.munit.Assert;
using unit.Asserts;


class SelectorTest {

	@Before
	public function setup() {
	}

	@Test
	public function should_calling_selector_query_return_valid_expression() {
		var selector = new Selector();
		selector.query("body  .name-of-something>#title  :first-child");
	}
}
