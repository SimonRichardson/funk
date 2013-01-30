package suites;

import massive.munit.TestSuite;

import funk.actors.ActorTest;
import funk.actors.types.mvc.ModelTest;

class ActorsSuite extends TestSuite {

	public function new()
	{
		super();

		add(funk.actors.ActorTest);

		add(funk.actors.types.mvc.ModelTest);
	}
}
