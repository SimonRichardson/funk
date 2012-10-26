package funk.signal;

import funk.errors.AbstractMethodError;
import funk.signal.Signal;

import massive.munit.Assert;
import massive.munit.AssertExtensions;

using massive.munit.Assert;
using massive.munit.AssertExtensions;

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

	@Test
	public function when_creating_a_slot__should_productArity_be_minus_1() : Void {
		slot.productArity.areEqual(-1);
	}

	@Test
	public function when_creating_a_slot__should_productPrefix_be_Signal() : Void {
		slot.productPrefix.areEqual("Slot");
	}

	@Test
	public function when_creating_a_slot__should_calling_productElement_throw_error() : Void {
		var called = try {
			slot.productElement(0);
			false;
		} catch(error : AbstractMethodError) {
			true;
		}
		called.isTrue();
	}

}
