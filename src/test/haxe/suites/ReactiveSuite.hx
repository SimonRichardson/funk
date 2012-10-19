package suites;

import massive.munit.TestSuite;

import funk.reactive.CollectionsTest;
import funk.reactive.StreamsTest;

class ReactiveSuite extends TestSuite
{

	public function new()
	{
		super();

		add(funk.reactive.CollectionsTest);
		add(funk.reactive.StreamTest);
		add(funk.reactive.StreamsTest);
	}
}
