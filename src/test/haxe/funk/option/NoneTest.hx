package funk.option;

import funk.either.Either;
import funk.errors.NoSuchElementError;
import funk.errors.RangeError;
import funk.option.Option;
import massive.munit.Assert;
import massive.munit.AssertExtensions;

using funk.option.Option;
using massive.munit.Assert;
using massive.munit.AssertExtensions;

class NoneTest {

	@Test
	public function should_creating_None_should_not_be_null() {
		None.isNotNull();
	}

	@Test
	public function should_calling_get_on_None_should_throw_Error() {
		var called = try {
			None.get();
			false;
		} catch(error : NoSuchElementError) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function should_calling_getOrElse_on_None_should_return_other_value() {
		None.getOrElse(function() {
			return 2;
		}).areEqual(2);
	}

	@Test
	public function should_calling_getOrElse_on_None_with_null_should_throw_Error() {
		var called = try {
			None.getOrElse(null);
			false;
		} catch(error : Dynamic) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function should_calling_None_isDefined_is_false() {
		None.isDefined().isFalse();
	}

	@Test
	public function should_calling_None_isEmpty_is_true() {
		None.isEmpty().isTrue();
	}


	@Test
	public function when_filter_on_None_should_not_filter_if_called() {
        None.filter(function (v) {
            Assert.fail("failed if called");
            return false;
        });
    }

    @Test
    public function when_foreach_on_None_should_not_iterate_if_called() {
        None.foreach(function (v) {
            Assert.fail("failed if callled");
        });
    }

    @Test
    public function when_flatMap_on_None_should_not_iterate_if_called() {
    	None.flatMap(function (v) {
            Assert.fail("failed if called");
            return None;
        });
    }

    @Test
    public function when_map_on_None_should_not_iterate_if_called() {
    	None.map(function (v) {
            Assert.fail("failed if called");
        });
    }

    @Test
    public function when_orElse_on_None_should_calling_orElse_return_a_valid_option_type() {
    	None.orElse(function () {
            return Some(true);
        }).isEnum(Option);
    }

    @Test
    public function when_orElse_on_None_should_calling_return_false() {
    	None.orElse(function () {
            return Some(false);
        }).get().isFalse();
    }

    @Test
    public function when_equals_on_None_should_equal_None() {
    	None.equals(None).isTrue();
    }

	@Test
    public function when_equals_on_None_should_not_equal_Some_false() {
    	None.equals(Some(false)).isFalse();
    }

	@Test
    public function when_equals_on_None_should_not_equal_Some_null() {
    	None.equals(Some(null)).isFalse();
    }

    @Test
    public function when_equals_on_None_should_not_equal_Some_int() {
    	None.equals(Some(1)).isFalse();
    }

    @Test
    public function when_equals_on_None_should_not_equal_Some_true() {
    	None.equals(Some(true)).isFalse();
    }

    @Test
    public function when_toString_on_None_should_equal_None() {
        None.toString().areEqual("None");
    }

    @Test
    public function when_toEither_on_None_should_return_Either() {
        None.toEither(function(){
            return false;
        }).isEnum(Either);
    }

    @Test
    public function when_toOption_on_null_should_return_Option() {
        Options.toOption(null).isEnum(Option);
    }

    @Test
    public function when_toOption_on_null_should_return_None() {
        Options.toOption(null).isEmpty().isTrue();
    }

    @Test
    public function when_product_on_None_should_have_product_arity_of_0() {
    	None.toInstance().productArity.areEqual(0);
    }

    @Test
    public function when_product_on_None_should_have_productPrefix_of_None() {
        None.toInstance().productPrefix.areEqual("None");
    }

	@Test
    public function when_product_on_None_should_throw_RangeError() {
        var called = try {
        	None.toInstance().productElement(1);
        	false;
        } catch(error : RangeError) {
        	true;
        }
        called.isTrue();
    }

    @Test
    public function should_calling_equals_on_a_ProductObject_with_same_instance_isTrue() {
        var instance = None.toInstance();
        instance.equals(instance).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_ProductObject_with_instance_isTrue() {
        None.toInstance().equals(None.toInstance()).isTrue();
    }
}
