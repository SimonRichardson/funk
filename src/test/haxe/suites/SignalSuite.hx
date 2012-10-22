package suites;

import massive.munit.TestSuite;

import funk.signal.SignalTest;
import funk.signal.SlotTest;

class SignalSuite extends TestSuite
{

	public function new()
	{
		super();

		add(funk.signal.SignalTest);
		add(funk.signal.SlotTest);
	}
}
