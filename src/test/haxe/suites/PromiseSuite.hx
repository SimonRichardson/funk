package suites;

import massive.munit.TestSuite;

import funk.types.DeferredTest;
import funk.types.PromiseTest;

class PromiseSuite extends TestSuite {

	public function new() {
		super();

		add(funk.types.DeferredTest);
		add(funk.types.PromiseTest);
	}
}
