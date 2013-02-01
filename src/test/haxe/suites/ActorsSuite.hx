package suites;

import massive.munit.TestSuite;

import funk.actors.ActorTest;
import funk.actors.types.ProxyActorTest;
import funk.actors.types.UriActorTest;
import funk.actors.types.mvc.ModelTest;

class ActorsSuite extends TestSuite {

	public function new()
	{
		super();

		add(funk.actors.ActorTest);

        add(funk.actors.types.ProxyActorTest);
        add(funk.actors.types.UriActorTest);

		add(funk.actors.types.mvc.ModelTest);
	}
}
