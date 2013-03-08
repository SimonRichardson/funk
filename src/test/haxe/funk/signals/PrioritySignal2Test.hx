package funk.signals;

import funk.signals.PrioritySignal2;
import haxe.ds.Option;
import funk.types.extensions.Options;
import massive.munit.Assert;
import unit.Asserts;

using funk.types.extensions.Options;
using massive.munit.Assert;
using unit.Asserts;

class PrioritySignal2Test extends Signal2Test {

	private var prioritySignal : PrioritySignal2<Int, Int>;

	@Before
	override public function setup() {
		super.setup();

		var s = new PrioritySignal2<Int, Int>();
		signal = s;
		prioritySignal = s;

		signalName = 'PrioritySignal2';
	}

	@After
	override public function tearDown() {
		super.tearDown();

		prioritySignal = null;
	}

	@Test
	public function when_adding_two_items_with_larger_priority__should_dispatch_in_order() : Void {
		var called0 = false;
		var called1 = false;

		prioritySignal.addWithPriority(function(value0, value1){
			called0 = true;
		}, 1);
		prioritySignal.addWithPriority(function(value0, value1){
			if(called0) {
				called1 = true;
			}
		}, 2);
		prioritySignal.dispatch(1, 2);

		called1.isTrue();
	}

	@Test
	public function when_adding_three_items_with_larger_priority__should_dispatch_in_order() : Void {
		var called0 = false;
		var called1 = false;
		var called2 = false;

		prioritySignal.addWithPriority(function(value0, value1){
			called0 = true;
		}, 1);
		prioritySignal.addWithPriority(function(value0, value1){
			if(called0) {
				called1 = true;
			}
		}, 2);
		prioritySignal.addWithPriority(function(value0, value1){
			if(called1) {
				called2 = true;
			}
		}, 3);
		prioritySignal.dispatch(1, 2);

		called2.isTrue();
	}

	@Test
	public function when_adding_two_items_with_smaller_priority__should_dispatch_in_order() : Void {
		var called0 = false;
		var called1 = false;

		prioritySignal.addWithPriority(function(value0, value1){
			if(called0) {
				called1 = true;
			}
		}, 2);
		prioritySignal.addWithPriority(function(value0, value1){
			called0 = true;
		}, 1);
		prioritySignal.dispatch(1, 2);

		called1.isTrue();
	}

	@Test
	public function when_adding_three_items_with_smaller_priority__should_dispatch_in_order() : Void {
		var called0 = false;
		var called1 = false;
		var called2 = false;

		prioritySignal.addWithPriority(function(value0, value1){
			if(called1) {
				called2 = true;
			}
		}, 3);
		prioritySignal.addWithPriority(function(value0, value1){
			if(called0) {
				called1 = true;
			}
		}, 2);
		prioritySignal.addWithPriority(function(value0, value1){
			called0 = true;
		}, 1);
		prioritySignal.dispatch(1, 2);

		called2.isTrue();
	}

	@Test
	public function when_adding_three_items_with_mixed_priority__should_dispatch_in_order() : Void {
		var called0 = false;
		var called1 = false;
		var called2 = false;

		prioritySignal.addWithPriority(function(value0, value1){
			if(called0) {
				called1 = true;
			}
		}, 2);
		prioritySignal.addWithPriority(function(value0, value1){
			if(called1) {
				called2 = true;
			}
		}, 3);
		prioritySignal.addWithPriority(function(value0, value1){
			called0 = true;
		}, 1);
		prioritySignal.dispatch(1, 2);

		called2.isTrue();
	}

	@Test
	public function when_adding_with_priority__should_size_be_1() : Void {
		prioritySignal.addWithPriority(function(value0, value1){
		});
		prioritySignal.size().areEqual(1);
	}

	@Test
	public function when_adding_with_priority_after_dispatch__should_size_be_1() : Void {
		prioritySignal.addWithPriority(function(value0, value1){
		});
		prioritySignal.dispatch(1, 2);
		prioritySignal.size().areEqual(1);
	}

	@Test
	public function when_adding_once_with_priority__should_size_be_1() : Void {
		prioritySignal.addOnceWithPriority(function(value0, value1){
		});
		prioritySignal.size().areEqual(1);
	}

	@Test
	public function when_adding_once_with_priority_after_dispatch__should_size_be_1() : Void {
		prioritySignal.addOnceWithPriority(function(value0, value1){
		});
		prioritySignal.dispatch(1, 2);
		prioritySignal.size().areEqual(0);
	}

	@Test
	public function when_adding_adding_same_function_twice__should_return_same_slot() : Void {
		var func = function(value0, value1){
		};

		var slot = prioritySignal.addWithPriority(func);
		prioritySignal.addWithPriority(func).get().areEqual(slot.get());
	}
}
