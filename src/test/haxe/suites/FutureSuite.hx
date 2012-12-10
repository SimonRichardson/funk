package suites;

import massive.munit.TestSuite;

import funk.types.DeferredTest;
import funk.types.FutureTest;

class FutureSuite extends TestSuite
{

	public function new()
	{
		super();

		add(funk.types.DeferredTest);
		add(funk.types.FutureTest);
	}
}
