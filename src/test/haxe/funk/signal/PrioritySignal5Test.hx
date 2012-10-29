package funk.signal;

import funk.signal.PrioritySignal5;

import massive.munit.Assert;
import massive.munit.AssertExtensions;

using massive.munit.Assert;
using massive.munit.AssertExtensions;

class PrioritySignal5Test {

	private var signal : PrioritySignal5<Int, Int, Int, Int, Int>;

	@Before
	public function setup() {
		signal = new PrioritySignal5<Int, Int, Int, Int, Int>();
	}

	@After
	public function tearDown() {
		signal = null;
	}

	@Test
	public function when_adding_two_items_with_larger_priority__should_dispatch_in_order() : Void {
		var called0 = false;
		var called1 = false;

		signal.addWithPriority(function(value0, value1, value2, value3, value4){
			called0 = true;
		}, 1);
		signal.addWithPriority(function(value0, value1, value2, value3, value4){
			if(called0) {
				called1 = true;
			}
		}, 2);
		signal.dispatch(1, 2, 3, 4, 5);

		called1.isTrue();
	}

	@Test
	public function when_adding_three_items_with_larger_priority__should_dispatch_in_order() : Void {
		var called0 = false;
		var called1 = false;
		var called2 = false;

		signal.addWithPriority(function(value0, value1, value2, value3, value4){
			called0 = true;
		}, 1);
		signal.addWithPriority(function(value0, value1, value2, value3, value4){
			if(called0) {
				called1 = true;
			}
		}, 2);
		signal.addWithPriority(function(value0, value1, value2, value3, value4){
			if(called1) {
				called2 = true;
			}
		}, 3);
		signal.dispatch(1, 2, 3, 4, 5);

		called2.isTrue();
	}

	@Test
	public function when_adding_two_items_with_smaller_priority__should_dispatch_in_order() : Void {
		var called0 = false;
		var called1 = false;

		signal.addWithPriority(function(value0, value1, value2, value3, value4){
			if(called0) {
				called1 = true;
			}
		}, 2);
		signal.addWithPriority(function(value0, value1, value2, value3, value4){
			called0 = true;
		}, 1);
		signal.dispatch(1, 2, 3, 4, 5);

		called1.isTrue();
	}

	@Test
	public function when_adding_three_items_with_smaller_priority__should_dispatch_in_order() : Void {
		var called0 = false;
		var called1 = false;
		var called2 = false;

		signal.addWithPriority(function(value0, value1, value2, value3, value4){
			if(called1) {
				called2 = true;
			}
		}, 3);
		signal.addWithPriority(function(value0, value1, value2, value3, value4){
			if(called0) {
				called1 = true;
			}
		}, 2);
		signal.addWithPriority(function(value0, value1, value2, value3, value4){
			called0 = true;
		}, 1);
		signal.dispatch(1, 2, 3, 4, 5);

		called2.isTrue();
	}

	@Test
	public function when_adding_three_items_with_mixed_priority__should_dispatch_in_order() : Void {
		var called0 = false;
		var called1 = false;
		var called2 = false;

		signal.addWithPriority(function(value0, value1, value2, value3, value4){
			if(called0) {
				called1 = true;
			}
		}, 2);
		signal.addWithPriority(function(value0, value1, value2, value3, value4){
			if(called1) {
				called2 = true;
			}
		}, 3);
		signal.addWithPriority(function(value0, value1, value2, value3, value4){
			called0 = true;
		}, 1);
		signal.dispatch(1, 2, 3, 4, 5);

		called2.isTrue();
	}

	@Test
	public function when_adding_with_priority__should_size_be_1() : Void {
		signal.addWithPriority(function(value0, value1, value2, value3, value4){
		});
		signal.size.areEqual(1);
	}

	@Test
	public function when_adding_with_priority_after_dispatch__should_size_be_1() : Void {
		signal.addWithPriority(function(value0, value1, value2, value3, value4){
		});
		signal.dispatch(1, 2, 3, 4, 5);
		signal.size.areEqual(1);
	}

	@Test
	public function when_adding_once_with_priority__should_size_be_1() : Void {
		signal.addOnceWithPriority(function(value0, value1, value2, value3, value4){
		});
		signal.size.areEqual(1);
	}

	@Test
	public function when_adding_once_with_priority_after_dispatch__should_size_be_1() : Void {
		signal.addOnceWithPriority(function(value0, value1, value2, value3, value4){
		});
		signal.dispatch(1, 2, 3, 4, 5);
		signal.size.areEqual(0);
	}

	@Test
	public function when_adding_adding_same_function_twice__should_return_same_slot() : Void {
		var func = function(value0, value1, value2, value3, value4){
		};

		var slot = signal.addWithPriority(func);
		signal.addWithPriority(func).get().areEqual(slot.get());
	}
}
