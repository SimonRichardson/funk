package suites;

import massive.munit.TestSuite;

import funk.future.DeferredTest;
import funk.future.PromiseTest;

class FutureSuite extends TestSuite
{

	public function new()
	{
		super();

		add(funk.future.DeferredTest);
		add(funk.future.PromiseTest);
	}
}
