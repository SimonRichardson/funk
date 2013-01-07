package suites;

import massive.munit.TestSuite;

import funk.actors.ActorTest;

class ActorsSuite extends TestSuite
{

	public function new()
	{
		super();

		add(funk.actors.ActorTest);
	}
}
