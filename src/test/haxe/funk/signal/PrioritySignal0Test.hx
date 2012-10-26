package funk.signal;

import funk.signal.PrioritySignal0;

import massive.munit.Assert;
import massive.munit.AssertExtensions;

using massive.munit.Assert;
using massive.munit.AssertExtensions;

class PrioritySignal0Test {


	@Test
	public function when_adding_item_with_larger_priority__should_dispatch_in_order() : Void {
		var called0 = false;
		var called1 = false;

		var signal = new PrioritySignal0();
		signal.addWithPriority(function(){
			called0 = true;
		}, 1);
		signal.addWithPriority(function(){
			if(called0) {
				called1 = true;
			}
		}, 2);
		signal.dispatch();

		called1.isTrue();
	}

}
