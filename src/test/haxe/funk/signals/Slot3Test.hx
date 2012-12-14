package funk.signals;

import funk.types.Option;
import funk.types.extensions.Options;
import funk.signals.Signal3;
import massive.munit.Assert;
import unit.Asserts;

using funk.types.extensions.Options;
using massive.munit.Assert;
using unit.Asserts;

class Slot3Test {

	public var signal : Signal3<Int, Int, Int>;

	@Before
	public function setup() {
		signal = new Signal3<Int, Int, Int>();
	}

	@After
	public function tearDown() {
		signal = null;
	}

	@Test
	public function when_calling_execute__should_call_listener() : Void {
		var called = false;
		var listener = function(value0, value1, value2) {
			called = true;
		};
		var slot = new Slot3<Int, Int, Int>(signal, listener, false);
		slot.execute(1, 2, 3);
		called.isTrue();
	}

	@Test
	public function when_calling_execute_when_disabled__should_not_call_listener() : Void {
		var called = false;
		var listener = function(value0, value1, value2) {
			called = true;
		};
		var slot = new Slot3<Int, Int, Int>(signal, listener, false);
		slot.enabled = false;
		slot.execute(1, 2, 3);
		called.isFalse();
	}

	@Test
	public function when_calling_execute__should_leave_signal_with_one() : Void {
		var listener = function(value0, value1, value2) {};
		var slot = signal.add(listener).get();
		slot.execute(1, 2, 3);
		signal.size().areEqual(1);
	}

	@Test
	public function when_calling_execute_with_once__should_leave_signal_with_zero() : Void {
		var listener = function(value0, value1, value2) {};
		var slot = signal.addOnce(listener).get();
		slot.execute(1, 2, 3);
		signal.size().areEqual(0);
	}

	@Test
	public function when_calling_remove_twice__should_signal_with_zero_listeners() : Void {
		var listener = function(value0, value1, value2) {};
		var slot = signal.add(listener).get();
		slot.remove();
		slot.remove();
		signal.size().areEqual(0);
	}

	@Test
	public function when_calling_listener__should_return_same_listener() : Void {
		var listener = function(value0, value1, value2) {};
		var slot = new Slot3<Int, Int, Int>(signal, listener, false);
		slot.listener.areEqual(listener);
	}
}
