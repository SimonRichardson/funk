package funk.selector;

import funk.collections.immutable.List;
import funk.selector.Selector;

using funk.collections.immutable.extensions.Lists;
using massive.munit.Assert;
using unit.Asserts;


class SelectorTest {

	@Before
	public function setup() {
	}

	@Test
	public function should_calling_selector_query_return_valid_expression() {
		Selector.query("body>:first-child").foreach(function (expr) {
            switch(expr) {
                case ELine(value):
                    switch(value) {
                        case VTag(tag, next): trace(next);
                        default:
                    }
            }
        });
        trace(Selector.query("body  .name-of-something>#title  :first-child"));
        trace(Selector.query("body;  .name-of-something>#title;  :first-child"));
        trace(Selector.query("body > name"));
        trace(Selector.query("body + name"));
        trace(Selector.query("body ~ name"));
        trace(Selector.query("body name"));
	}
}
