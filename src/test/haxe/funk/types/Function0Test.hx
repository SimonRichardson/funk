package funk.types;

using Type;
using funk.types.Function0;
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

		a.flatMap(function(value) {
			return function() {
				return !value;
			};
		})();
	}

	@Test
	public function when_calling_promote__should_call_function() : Void {
		var called = false;
		var a = function() {
			called = true;
		};

		a.promote()(true);
		called.isTrue();
	}
}
