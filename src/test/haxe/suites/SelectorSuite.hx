package suites;

import massive.munit.TestSuite;

import funk.selector.SelectorTest;

class SelectorSuite extends TestSuite {

	public function new() {
		super();

		add(funk.selector.SelectorTest);
	}
}
