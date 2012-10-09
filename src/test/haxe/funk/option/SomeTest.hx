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
	public function should_calling_getOrElse_on_Some_instance_with_none_should_equal_value() {
		Some(1).toInstance().getOrElse(null).areEqual(1);
	}

	@Test
	public function should_calling_Some_isDefined_is_true() {
		Some(1).isDefined().isTrue();
	}

	@Test
	public function should_calling_Some_isEmpty_is_false() {
		Some(1).isEmpty().isFalse();
	}

	@Test
	public function should_calling_Some_get_return_same_value() {
		var value = {};
		Some(value).get().areEqual(value);
	}

	@Test
	public function should_calling_Some_with_null_and_calling_get_return_null() {
		Some(null).get();
	}

	@Test
	public function should_calling_getOrElse_not_call_the_else() {
		var value = {};
		Some(value).getOrElse(function(){
			Assert.fail("failed if called");
			return {};
		}).areEqual(value);
	}

	@Test
	public function should_calling_filter_when_Some_has_valid_object() {
		var called = false;
		Some({}).filter(function(v){
			called = true;
			return true;
		});
		called.isTrue();
	}

	@Test
	public function should_calling_filter_should_pass_value_into_function() {
		var value = {};
		Some(value).filter(function(v){
			value.areEqual(v);
			return true;
		});
	}

	@Test
	public function should_calling_filter_return_a_valid_option() {
		Some({}).filter(function(v){
			return true;
		}).isEnum(Option);
	}

	@Test
	public function should_calling_filter_with_false_return_None() {
		Some({}).filter(function(v){
			return false;
		}).isDefined().isFalse();
	}

	@Test
	public function should_calling_filter_with_true_return_None() {
		Some({}).filter(function(v){
			return true;
		}).isDefined().isTrue();
	}

	@Test
	public function should_calling_filter_with_instance_with_true_return_None() {
		Some({}).toInstance().filter(function(v){
			return true;
		}).isDefined().isTrue();
	}

	@Test
	public function should_calling_foreach_on_Some_iterate_once() {
		var count = 0;
		Some({}).foreach(function(v){
			count++;
		});
		count.areEqual(1);
	}

	@Test
	public function should_calling_foreach_on_Some_pass_value() {
		var value = {};
		Some(value).foreach(function(v){
			value.areEqual(v);
		});
	}

	@Test
	public function should_calling_foreach_on_Some_instance_pass_value() {
		var value = {};
		Some(value).toInstance().foreach(function(v){
			value.areEqual(v);
		});
	}

	@Test
	public function should_calling_flatmap_on_Some_should_call_function() {
		var called = false;
		Some({}).flatMap(function(v){
			called = true;
			return None;
		});
		called.isTrue();
	}

	@Test
	public function should_calling_flatmap_on_Some_should_call_value() {
		var value = {};
		Some(value).flatMap(function(v){
			value.areEqual(v);
			return None;
		});
	}

	@Test
	public function should_calling_flatmap_on_Some_should_return_valid_Option() {
		Some({}).flatMap(function(v){
			return None;
		}).isEnum(Option);
	}

	@Test
	public function should_calling_flatmap_on_Some_instance_should_return_valid_Option() {
		Some({}).toInstance().flatMap(function(v){
			return None;
		}).isEnum(Option);
	}

	@Test
	public function should_calling_map_on_Some_should_call_function() {
		var called = false;
		Some({}).map(function(v){
			called = true;
			return v;
		});
		called.isTrue();
	}

	@Test
	public function should_calling_map_on_Some_should_call_value() {
		var value = {};
		Some(value).map(function(v){
			value.areEqual(v);
			return v;
		});
	}

	@Test
	public function should_calling_map_on_Some_should_return_valid_Option() {
		Some({}).map(function(v){
			return v;
		}).isEnum(Option);
	}

	@Test
	public function should_calling_map_on_Some_instance_should_return_valid_Option() {
		Some({}).toInstance().map(function(v){
			return v;
		}).isEnum(Option);
	}

	@Test
	public function should_calling_orElse_on_Some_not_call_function() {
		var value = {};
		Some(value).orElse(function(){
			Assert.fail("failed if called");
			return None;
		}).get().areEqual(value);
	}

	@Test
	public function should_calling_orElse_on_Some_instance_should_not_call_function() {
		var value = {};
		Some(value).toInstance().orElse(function(){
			Assert.fail("failed if called");
			return None;
		}).get().areEqual(value);
	}

	@Test
    public function when_equals_on_Some_null_should_equal_Some() {
    	var value = null;
    	Some(value).equals(Some(value)).isTrue();
    }

    @Test
    public function when_equals_on_Some_value_should_equal_Some() {
    	var value = {};
    	Some(value).equals(Some(value)).isTrue();
    }

    @Test
    public function when_equals_on_Some_value_should_equal_Some_different_value() {
    	Some({}).equals(Some({})).isFalse();
    }

	@Test
    public function when_equals_on_Some_false_should_not_equal_None() {
    	Some(false).equals(None).isFalse();
    }

	@Test
    public function when_equals_on_Some_null_should_not_equal_None() {
    	Some(null).equals(None).isFalse();
    }

    @Test
    public function when_equals_on_Some_int_should_not_equal_None() {
    	Some(1).equals(None).isFalse();
    }

    @Test
    public function when_equals_on_Some_true_should_not_equal_None() {
    	Some(true).equals(None).isFalse();
    }

    @Test
    public function when_toString_on_Some_should_equal_Some_true() {
        Some(true).toString().areEqual("Some(true)");
    }

    @Test
    public function when_toString_on_Some_should_equal_Some_1() {
        Some(1).toString().areEqual("Some(1)");
    }

    @Test
    public function when_toString_on_Some_should_equal_Some_Array() {
        Some([1,2,3]).toString().areEqual("Some([1,2,3])");
    }

    @Test
    public function when_toEither_on_Some_should_return_Either() {
        Some(true).toEither(function(){
            return false;
        }).isEnum(Either);
    }

    @Test
    public function when_toEither_on_Some_instance_should_return_Either() {
        Some(true).toInstance().toEither(function(){
            return false;
        }).isEnum(Either);
    }

    @Test
    public function when_toOption_on_true_should_return_Option() {
        Options.toOption(true).isEnum(Option);
    }

    @Test
    public function when_toOption_on_true_should_return_Some() {
        Options.toOption(true).isDefined().isTrue();
    }

    @Test
    public function when_calling_productIterator_on_Some_isNotNull() {
        Some(true).productIterator().isNotNull();
    }

    @Test
    public function when_product_on_Some_should_have_product_arity_of_1() {
    	Some({}).toInstance().productArity.areEqual(1);
    }

    @Test
    public function when_product_on_Some_should_have_productPrefix_of_Some() {
        Some(true).toInstance().productPrefix.areEqual("Some");
    }

    @Test
    public function when_product_on_Some_should_have_toString_of_Some_true() {
        Some(true).toInstance().toString().areEqual("Some(true)");
    }

    @Test
    public function when_product_on_Some_should_have_toString_of_Some_Array() {
        Some([1,2,3]).toInstance().toString().areEqual("Some([1,2,3])");
    }

	@Test
    public function when_product_on_Some_should_throw_RangeError() {
        var called = try {
        	Some(true).toInstance().productElement(2);
        	false;
        } catch(error : RangeError) {
        	true;
        }
        called.isTrue();
    }

    @Test
    public function should_calling_equals_on_a_ProductObject_with_same_instance_isTrue() {
        var instance = Some(true).toInstance();
        instance.equals(instance).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_ProductObject_with_instance_isTrue() {
        Some(true).toInstance().equals(Some(true).toInstance()).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Some_with_None_isFalse() {
        Some(true).toInstance().equals(None.toInstance()).isFalse();
    }

    @Test
    public function should_calling_equals_on_a_ProductObject_with_nested_Option_should_be_true() {
        Some(Some(true)).toInstance().equals(Some(Some(true)).toInstance()).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_ProductObject_with_nested_Some_and_None_should_be_false() {
        Some(Some(true)).toInstance().equals(Some(None).toInstance()).isFalse();
    }

    @Test
    public function should_calling_equals_on_a_ProductObject_with_nested_Some_instance_and_None_instance_should_be_false() {
        Some(Some(true).toInstance()).toInstance().equals(Some(None.toInstance()).toInstance()).isFalse();
    }

    @Test
    public function should_calling_deeply_nested_Some_be_equal_to_shallow_Some() {
        Some(Some(Some(Some(true)))).toInstance().equals(Some(true).toInstance()).isTrue();
    }

    @Test
    public function should_calling_deeply_nested_Some_with_true_be_not_equal_to_shallow_Some_with_false() {
        Some(Some(Some(Some(true)))).toInstance().equals(Some(Some(Some(Some(false)))).toInstance()).isFalse();
    }

    @Test
    public function should_calling_deeply_nested_Some_with_true_be_not_equal_to_shallow_None() {
        Some(Some(Some(Some(true)))).toInstance().equals(None.toInstance()).isFalse();
    }
}
