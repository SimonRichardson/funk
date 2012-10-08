package funk.option;

import funk.errors.NoSuchElementError;
import funk.option.Option;
import massive.munit.Assert;

using funk.option.Option;
using massive.munit.Assert;

class SomeTest {

	@Test
	public function should_creating_Some_should_not_be_null() {
		Some(1).isNotNull();
	}

	@Test
	public function should_calling_get_on_Some_should_equal_value() {
		Some(1).get().areEqual(1);
	}

	@Test
	public function should_calling_getOrElse_on_Some_should_equal_value() {
		Some(1).getOrElse(function() {
			return 1;
		}).areEqual(1);
	}

	@Test
	public function should_calling_getOrElse_on_Some_with_none_should_equal_value() {
		Some(1).getOrElse(null).areEqual(1);
	}

	@Test
	public function should_calling_Some_isDefined_is_true() {
		Some(1).isDefined().isTrue();
	}

	@Test
	public function should_calling_Some_isEmpty_is_false() {
		Some(1).isEmpty().isFalse();
	}
}
