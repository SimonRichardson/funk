package suites;

import massive.munit.TestSuite;

import funk.future.DeferredTest;
import funk.future.FutureTest;

class FutureSuite extends TestSuite
{

	public function new()
	{
		super();

		add(funk.future.DeferredTest);
		add(funk.future.FutureTest);
	}
}
