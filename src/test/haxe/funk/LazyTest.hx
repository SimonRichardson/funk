package funk;

import funk.Lazy;
import massive.munit.Assert;

using funk.Lazy;
using massive.munit.Assert;

class LazyTest {

	@Test
	public function when_calling_lazy__should_return_value() : Void {
		var instance = {};
		lazy(function() {
			return instance;
		}).get()().areEqual(instance);
	}

	@Test
	public function when_calling_lazy_twice__should_return_same_value() : Void {
		var instance = {};
		var lax = lazy(function() {
			return instance;
		});
		lax.get()();
		lax.get()().areEqual(instance);
	}

	@Test
	public function when_calling_lazy_twice__should_return_same_instance() : Void {
		var lax = lazy(function() {
			return {};
		}).get();
		lax().areEqual(lax());
	}

	@Test
	public function when_calling_lazy_twice__should_be_called_once() : Void {
		var amount = 0;
		var lax = lazy(function() {
			amount++;
			return {};
		}).get();
		lax();
		lax();
		amount.areEqual(1);
	}

	@Test
	public function when_calling_lazy_call__should_call_func() : Void {
		var instance = {};
		lazy(function() {
			return instance;
		}).call().areEqual(instance);
	}
}
