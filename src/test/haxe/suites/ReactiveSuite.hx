package suites;

import massive.munit.TestSuite;

import funk.reactive.CollectionsTest;
import funk.reactive.StreamTest;
import funk.reactive.StreamsTest;

class ReactiveSuite extends TestSuite
{

	public function new()
	{
		super();

		add(funk.reactive.CollectionsTest);
		add(funk.reactive.StreamTest);
		add(funk.reactive.StreamsTest);

		add(funk.reactive.signals.SignalSignal0Test);
		add(funk.reactive.signals.SignalSignal1Test);
		add(funk.reactive.signals.SignalSignal2Test);
		add(funk.reactive.signals.SignalSignal3Test);
		add(funk.reactive.signals.SignalSignal4Test);
		add(funk.reactive.signals.SignalSignal5Test);
	}
}
