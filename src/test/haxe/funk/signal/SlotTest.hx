package funk.signal;

import funk.signal.Signal;
import massive.munit.Assert;
import unit.Asserts;

using massive.munit.Assert;
using unit.Asserts;

class SlotTest {

	private var slot : Slot;

	@Before
	public function setup() {
		slot = new Slot();
	}

	@After
	public function tearDown() {
		slot = null;
	}

	@Test
	public function when_creating_a_slot__should_not_be_null() : Void {
		slot.isNotNull();
	}
}
