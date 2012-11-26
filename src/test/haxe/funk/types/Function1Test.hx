package funk.types;

import Type;
import funk.types.Function0;
import funk.types.Tuple1;
import funk.types.extensions.Functions1;
import funk.types.extensions.Tuples1;
import massive.munit.Assert;

using Type;
using funk.types.extensions.Functions1;
using funk.types.extensions.Tuples1;
using massive.munit.Assert;

class Function1Test {

	@Test
	public function when_calling__1__should_call_function() : Void {
		var called = false;
		var a = function(value1) {
			called = value1;
		};
		a._1(true)();
		called.isTrue();
	}

	@Test
	public function when_calling_compose__should_call_function_and_return_correct_response() : Void {
		var a = function(value) {
			return value;
		};

		var b = a.compose(function(value){
			return !value;
		})(false);

		b.isTrue();
	}

	@Test
	public function when_calling_map__should_call_function() : Void {
		var a = function(value) {
			return value;
		};

		var b = a.map(function(value){
			return !value;
		})(false);

		b.isTrue();
	}

	@Test
	public function when_calling_curry__should_call_function() : Void {
		var called = false;
		var a = function(value) {
			called = true;
			return value;
		};
		a.curry()(true);
		called.isTrue();
	}

	@xTest
	public function when_calling_uncurry__should_call_function() : Void {
		/**
		 * FIXME (Simon) : This is broken in the latest release of haxe.
		var called = false;
		var a = function(value) {
			return function () {
				called = true;
				return value;	
			}
		}.uncurry();
		called.isTrue();
		*/
	}

	@Test
	public function when_calling_tuple__should_call_function() : Void {
		var a = function(value) {
			return value;
		}.tuple()(tuple1(true));
		a.isTrue();
	}

	@Test
	public function when_calling_untuple__should_call_function() : Void {
		var a = function(t : Tuple1<Bool>) {
			return t;
		}.untuple()(true);
		a.areEqual(tuple1(true));
	}
}
