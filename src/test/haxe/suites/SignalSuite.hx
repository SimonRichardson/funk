package suites;

import massive.munit.TestSuite;

import funk.signal.SignalTest;
import funk.signal.SlotTest;
import funk.signal.Signal0Test;
import funk.signal.Signal1Test;
import funk.signal.Signal2Test;
import funk.signal.Signal3Test;
import funk.signal.Signal4Test;
import funk.signal.Signal5Test;
import funk.signal.PrioritySignal0Test;
import funk.signal.PrioritySignal1Test;
import funk.signal.PrioritySignal2Test;
import funk.signal.PrioritySignal3Test;
import funk.signal.PrioritySignal4Test;
import funk.signal.PrioritySignal5Test;

class SignalSuite extends TestSuite
{

	public function new()
	{
		super();

		add(funk.signal.SignalTest);
		add(funk.signal.SlotTest);

		add(funk.signal.Signal0Test);
		add(funk.signal.Signal1Test);
		add(funk.signal.Signal2Test);
		add(funk.signal.Signal3Test);
		add(funk.signal.Signal4Test);
		add(funk.signal.Signal5Test);

		add(funk.signal.PrioritySignal0Test);
		add(funk.signal.PrioritySignal1Test);
		add(funk.signal.PrioritySignal2Test);
		add(funk.signal.PrioritySignal3Test);
		add(funk.signal.PrioritySignal4Test);
		add(funk.signal.PrioritySignal5Test);
	}
}
