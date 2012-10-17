package suites;

import massive.munit.TestSuite;

import funk.reactive.StreamsTest;

class ReactiveSuite extends TestSuite
{

	public function new()
	{
		super();

		add(funk.reactive.StreamsTest);
	}
}
