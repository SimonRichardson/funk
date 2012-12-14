package funk.signals;

import massive.munit.Assert;
import unit.Asserts;

using massive.munit.Assert;
using unit.Asserts;

class SignalTest {

	private var signal : Signal;

	@Before
	public function setup() {
		signal = new Signal();
	}

	@After
	public function tearDown() {
		signal = null;
	}

	@Test
	public function when_creating_a_signal__should_not_be_null() : Void {
		signal.isNotNull();
	}

	@Test
	public function when_creating_a_signal__should_size_be_minus_1() : Void {
		signal.size().areEqual(-1);
	}

	@Test
	public function when_calling_removeAll__should_size_be_minus_1() : Void {
		signal.removeAll();
		signal.size().areEqual(-1);
	}

}
