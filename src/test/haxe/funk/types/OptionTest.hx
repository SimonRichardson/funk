package funk.types;

import funk.types.Either;
import funk.types.Option;
import funk.types.extensions.Eithers;
import funk.types.extensions.Options;
import massive.munit.Assert;

using funk.types.extensions.Eithers;
using funk.types.extensions.Options;
using massive.munit.Assert;

class OptionTest {

	@Test
	public function should_creating_None_should_not_be_null() {
		None.isNotNull();
	}

	@Test
	public function should_calling_get_on_None_should_throw_Error() {
		var called = try {
			None.get();
			false;
		} catch(error : Dynamic) {
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
        None.each(function (v) {
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
        }).isType(Option);
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
        }).isType(Either);
    }

    @Test
    public function when_toOption_on_null_should_return_Option() {
        Options.toOption(null).isType(Option);
    }

    @Test
    public function when_toOption_on_null_should_return_None() {
        Options.toOption(null).isEmpty().isTrue();
    }



















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
    public function should_calling_foreach_on_Some_iterate_once() {
        var count = 0;
        Some({}).each(function(v){
            count++;
        });
        count.areEqual(1);
    }

    @Test
    public function should_calling_foreach_on_Some_pass_value() {
        var value = {};
        Some(value).each(function(v){
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
    public function should_calling_orElse_on_Some_not_call_function() {
        var value = {};
        Some(value).orElse(function(){
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
    public function when_toOption_on_true_should_return_Option() {
        Options.toOption(true).isType(Option);
    }

    @Test
    public function when_toOption_on_true_should_return_Some() {
        Options.toOption(true).isDefined().isTrue();
    }
}