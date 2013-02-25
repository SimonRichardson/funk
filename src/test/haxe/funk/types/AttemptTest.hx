package funk.types;

import funk.Funk;
import funk.types.Attempt;
import funk.types.Attempt;
import haxe.ds.Option;
import funk.types.extensions.Attempts;
import funk.types.extensions.Attempts;
import funk.types.extensions.Options;
import massive.munit.Assert;

using funk.types.extensions.Attempts;
using funk.types.extensions.Attempts;
using funk.types.extensions.Options;
using massive.munit.Assert;

class AttemptTest {

	@Test
	public function should_failure_not_be_null() {
		Failure(Error("Failure")).isNotNull();
	}

	@Test
	public function should_success_not_be_null() {
		Success(1).isNotNull();
	}

	@Test
	public function should_failure_be_isFailure_isTrue() {
		Failure(Error("Failure")).isFailure().isTrue();
	}

	@Test
	public function should_failure_be_isSuccessful_isFalse() {
		Failure(Error("Failure")).isSuccessful().isFalse();
	}

	@Test
	public function should_success_be_isFailure_isFalse() {
		Success(1).isFailure().isFalse();
	}

	@Test
	public function should_success_be_isSuccessful_isTrue() {
		Success(1).isSuccessful().isTrue();
	}

	@Test
	public function should_creating_failure_return_valid_option() {
		Failure(Error("Failure")).failure().areEqual(Some(Error("Failure")));
	}

	@Test
	public function should_creating_failure_return_isDefined() {
		Failure(Error("Failure")).failure().isDefined().isTrue();
	}

	@Test
	public function should_creating_failure_with_value_return_same_value() {
		Failure(Error("Failure")).failure().get().areEqual(Error("Failure"));
	}

	@Test
	public function should_creating_failure_calling_success_returns_valid_option() {
		Failure(Error("Failure")).success().areEqual(None);
	}

	@Test
	public function should_creating_failure_calling_success_returns_none() {
		Failure(Error("Failure")).success().isEmpty().isTrue();
	}

	@Test
	public function should_creating_success_return_valid_option() {
		var value = {};
		Success(value).success().areEqual(Some(value));
	}

	@Test
	public function should_creating_success_return_isDefined() {
		Success({}).success().isDefined().isTrue();
	}

	@Test
	public function should_creating_success_with_value_return_same_value() {
		var value = {};
		Success(value).success().get().areEqual(value);
	}

	@Test
	public function should_creating_success_calling_success_returns_valid_option() {
		var value = {};
		Success(value).failure().areEqual(None);
	}

	@Test
	public function should_creating_success_calling_success_returns_none() {
		Success({}).failure().isEmpty().isTrue();
	}

	@Test
	public function should_creating_success_and_calling_swap_returns_valid_Attempt() {
		var value = {};
		Success(value).swap().areEqual(Failure(Error("Failure")));
	}

	@Test
	public function should_creating_success_and_calling_swap_returns_failure() {
		Success({}).swap().isFailure().isTrue();
	}

	@Test
	public function should_creating_success_and_calling_swap_returns_Some_with_error() {
		var value = {};
		Success(value).swap().failure().areEqual(Some(Error("Failure")));
	}

	@Test
	public function should_creating_failure_and_calling_swap_returns_valid_Attempt() {
		Failure(Error("Failure")).swap().areEqual(Success(Error("Failure")));
	}

	@Test
	public function should_creating_failure_and_calling_swap_returns_success() {
		Failure(Error("Failure")).swap().isSuccessful().isTrue();
	}

	@Test
	public function should_creating_failure_and_calling_swap_returns_origin_value() {
		Failure(Error("Failure")).swap().success().get().areEqual(Error("Failure"));
	}

	@Test
	public function should_calling_toString_should_return_Failure_1() {
		Failure(Error("Failure")).toString().areEqual("Failure(Error(Failure))");
	}

	@Test
	public function should_calling_toString_should_return_Success_1() {
		Success(1).toString().areEqual("Success(1)");
	}

	@Test
	public function should_calling_toOption_on_failure_return_valid_Option() {
		Failure(Error("Failure")).toOption().areEqual(None);
	}

	@Test
	public function should_calling_toOption_on_failure_return_None() {
		Failure(Error("Failure")).toOption().isEmpty().isTrue();
	}

	@Test
	public function should_calling_toOption_on_success_return_valid_Option() {
		Success(1).toOption().areEqual(Some(1));
	}

	@Test
	public function should_calling_toOption_on_success_return_Some() {
		Success(1).toOption().isDefined().isTrue();
	}

	@Test
	public function should_calling_toOption_on_success_return_Some_value() {
		var value = {};
		Success(value).toOption().get().areEqual(value);
	}

	@Test
	public function should_calling_fold_on_failure_should_return_notNull() {
		Failure(Error("Failure")).fold(function(value){
				return value;
			}, function(value){
				return value;
			}).isNotNull();
	}

	@Test
	public function should_calling_fold_on_failure_should_return_same_value() {
		Failure(Error("Failure")).fold(function(value){
				return value;
			}, function(value){
				return value;
			}).areEqual(Error("Failure"));
	}

	@Test
	public function should_calling_fold_on_success_should_return_notNull() {
		Success({}).fold(function(value){
				return value;
			}, function(error){
				return cast error;
			}).isNotNull();
	}

	@Test
	public function should_calling_fold_on_success_should_return_same_value() {
		var value = {};
		Success(value).fold(function(value){
				return value;
			}, function(value){
				return cast value;
			}).areEqual(value);
	}

	@Test
    public function should_calling_equals_on_a_Attempt_failure_with_same_value_isTrue() {
        var value = Failure(Error("Failure"));
        value.equals(value).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Attempt_success_with_same_value_isTrue() {
        var value = Success(true);
        value.equals(value).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Attempt_failure_with_value_isTrue() {
        Failure(Error("Failure")).equals(Failure(Error("Failure"))).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Attempt_success_with_value_isTrue() {
        Success(true).equals(Success(true)).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Failure_with_Success_isFalse() {
        Failure(Error("Failure")).equals(Success(true)).isFalse();
    }

    @Test
    public function should_calling_equals_on_a_Success_with_Failure_isFalse() {
        Success(true).equals(Failure(Error("Failure"))).isFalse();
    }

    @Test
    public function should_calling_equals_on_a_Success_with_Option_and_Success_with_Option_isTrue() {
        Success(Some(true)).equals(Success(Some(true)), null, function(a, b) {
        	return a == b;
        }).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Success_with_Option_and_Failure_with_Option_isFalse() {
        Success(Some(true)).equals(Failure(Error("Failure")), function(a, b) {
        	return a.get() == b.get();
        }).isFalse();
    }

    @Test
    public function should_calling_equals_on_a_Success_with_Option_and_Success_with_Option_value_isFalse() {
        Success(Some(true)).equals(Success(Some(false)), function(a, b) {
        	return a.get() == b.get();
        }).isFalse();
    }

    @Test
    public function should_calling_equals_on_a_Success_with_same_funk_object_isTrue() {
    	var value = {};
        Success(value).equals(Success(value), function(a, b) {
        	return a == b;
        }).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Failure_with_same_funk_object_isTrue() {
    	var value = Error("Failure");
        Failure(value).equals(Failure(value), function(a, b) {
        	return a == b;
        }).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Success_with_funk_object_isFalse() {
        Success({}).equals(Success({}), function(a, b) {
        	return a == b;
        }).isFalse();
    }

    @Test
    public function should_calling_equals_on_a_Failure_with_funk_object_isFalse() {
        Failure(Error("Failure")).equals(Failure(Error("Failure")), function(a, b) {
        	return a == b;
        }).isTrue();
    }
}
