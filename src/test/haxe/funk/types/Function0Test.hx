package funk.types;

import Type;
import funk.types.Function0;
import funk.types.extensions.Functions0;
import massive.munit.Assert;

using Type;
using funk.types.extensions.Functions0;
using massive.munit.Assert;

class Function0Test {

	@Test
	public function when_calling__0__should_call_function() : Void {
		var called = false;
		var a = function() {
			called = true;
		};
		a._0()();
		called.isTrue();
	}

	@Test
	public function when_calling_map__should_call_function() : Void {
		var called = false;
		var a = function() { return true; };
		a.map(function(value : Bool) {
			called = true;
			return false;
		})();
		called.isTrue();
	}

	@Test
	public function when_calling_map__should_map_function() : Void {
		var a = function() { return false; };
		var value = a.map(function(value : Bool) {
			return !value;
		})();
		value.isTrue();
	}

	@xTest
	public function when_calling_flatMap__should_call_function() : Void {
		var a = function() { return false; };
		
		/**
		 * FIXME (Simon) : This is broken in the latest release of haxe.
		a.flatMap(function(value) {
			return function() {
				return !value;
			};
		})();
		*/
	}

	@Test
	public function when_calling_promote__should_call_function() : Void {
		var called = false;
		var a = function() { 
			called = true;
			return true; 
		};
		a.promote()(true);
		called.isTrue();
	}

	@Test
	public function when_calling_wait__should_not_call_function() : Void {
		var called = false;
		var a = function() {
			called = true;
			return true;
		}

		var aa = a.wait();
		called.isFalse();
	}

	@Test
	public function when_calling_wait_then_yield__should_call_function() : Void {
		var called = false;
		var a = function() {
			called = true;
			return true;
		}

		var aa = a.wait();
		aa.yield();

		called.isTrue();
	}

	@Test
	public function when_chaining_wait_then_yield__should_call_second_function() : Void {
		var called0 = false;
		var called1 = false;

		var a = function() {
			called0 = true;
			return true;
		}
		var b = function() {
			called1 = true;
			return true;
		}

		var aa = a.wait();
		var bb = b.wait(aa);

		bb.yield();

		called1.isTrue();
	}

	@Test
	public function when_chaining_wait_then_yield__should_call_first_function() : Void {
		var called0 = false;
		var called1 = false;

		var a = function() {
			called0 = true;
			return true;
		}
		var b = function() {
			called1 = true;
			return true;
		}

		var aa = a.wait();
		var bb = b.wait(aa);

		bb.yield();

		called0.isTrue();
	}
}
