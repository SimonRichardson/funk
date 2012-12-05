package suites;

import massive.munit.TestSuite;

import funk.reactive.CollectionsTest;
/*import funk.reactive.StreamTest;
import funk.reactive.StreamsTest;
import funk.reactive.StreamValuesTest;

import funk.reactive.behaviours.BehaviourSignal0Test;
import funk.reactive.behaviours.BehaviourSignal1Test;
import funk.reactive.behaviours.BehaviourSignal2Test;
import funk.reactive.behaviours.BehaviourSignal3Test;
import funk.reactive.behaviours.BehaviourSignal4Test;
import funk.reactive.behaviours.BehaviourSignal5Test;*/

class ReactiveSuite extends TestSuite
{

	public function new()
	{
		super();

		add(funk.reactive.CollectionsTest);
		/*add(funk.reactive.StreamTest);
		add(funk.reactive.StreamsTest);
		add(funk.reactive.StreamValuesTest);

		add(funk.reactive.behaviours.BehaviourSignal0Test);
		add(funk.reactive.behaviours.BehaviourSignal1Test);
		add(funk.reactive.behaviours.BehaviourSignal2Test);
		add(funk.reactive.behaviours.BehaviourSignal3Test);
		add(funk.reactive.behaviours.BehaviourSignal4Test);
		add(funk.reactive.behaviours.BehaviourSignal5Test);*/
	}
}
