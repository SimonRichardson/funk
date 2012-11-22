package funk.types;

import funk.types.Either;
import funk.types.Option;
import funk.types.extensions.Eithers;
import funk.types.extensions.Options;
import massive.munit.Assert;

using funk.types.extensions.Eithers;
using funk.types.extensions.Options;
using massive.munit.Assert;

class EitherTest {

	@Test
	public function should_left_not_be_null() {
		Left(1).isNotNull();
	}

	@Test
	public function should_right_not_be_null() {
		Right(1).isNotNull();
	}

	@Test
	public function should_left_be_isLeft_isTrue() {
		Left(1).isLeft().isTrue();
	}

	@Test
	public function should_left_be_isRight_isFalse() {
		Left(1).isRight().isFalse();
	}

	@Test
	public function should_right_be_isLeft_isFalse() {
		Right(1).isLeft().isFalse();
	}

	@Test
	public function should_right_be_isRight_isTrue() {
		Right(1).isRight().isTrue();
	}

	@Test
	public function should_creating_left_return_valid_option() {
		var value = {};
		Left(value).left().isType(Option);
	}

	@Test
	public function should_creating_left_return_isDefined() {
		var value = {};
		Left(value).left().isDefined().isTrue();
	}

	@Test
	public function should_creating_left_with_instance_return_same_instance() {
		var value = {};
		Left(value).left().get().areEqual(value);
	}

	@Test
	public function should_creating_left_calling_right_returns_valid_option() {
		Left({}).right().isType(Option);
	}

	@Test
	public function should_creating_left_calling_right_returns_none() {
		Left({}).right().isEmpty().isTrue();
	}

	@Test
	public function should_creating_right_return_valid_option() {
		Right({}).right().isType(Option);
	}

	@Test
	public function should_creating_right_return_isDefined() {
		Right({}).right().isDefined().isTrue();
	}

	@Test
	public function should_creating_right_with_instance_return_same_instance() {
		var value = {};
		Right(value).right().get().areEqual(value);
	}

	@Test
	public function should_creating_right_calling_right_returns_valid_option() {
		Right({}).left().isType(Option);
	}

	@Test
	public function should_creating_right_calling_right_returns_none() {
		Right({}).left().isEmpty().isTrue();
	}

	@Test
	public function should_creating_right_and_calling_swap_returns_valid_Either() {
		Right({}).swap().isType(Either);
	}

	@Test
	public function should_creating_right_and_calling_swap_returns_left() {
		Right({}).swap().isLeft().isTrue();
	}

	@Test
	public function should_creating_right_and_calling_swap_returns_origin_instance() {
		var value = {};
		Right(value).swap().left().get().areEqual(value);
	}

	@Test
	public function should_creating_left_and_calling_swap_returns_valid_Either() {
		Left({}).swap().isType(Either);
	}

	@Test
	public function should_creating_left_and_calling_swap_returns_right() {
		Left({}).swap().isRight().isTrue();
	}

	@Test
	public function should_creating_left_and_calling_swap_returns_origin_instance() {
		var value = {};
		Left(value).swap().right().get().areEqual(value);
	}

	@Test
	public function should_calling_toString_should_return_Left_1() {
		Left(1).toString().areEqual("Left(1)");
	}

	@Test
	public function should_calling_toString_should_return_Right_1() {
		Right(1).toString().areEqual("Right(1)");
	}

	@Test
	public function should_calling_toOption_on_left_return_valid_Option() {
		Left(1).toOption().isType(Option);
	}

	@Test
	public function should_calling_toOption_on_left_return_None() {
		Left(1).toOption().isEmpty().isTrue();
	}

	@Test
	public function should_calling_toOption_on_right_return_valid_Option() {
		Right(1).toOption().isType(Option);
	}

	@Test
	public function should_calling_toOption_on_right_return_Some() {
		Right(1).toOption().isDefined().isTrue();
	}

	@Test
	public function should_calling_toOption_on_right_return_Some_value() {
		var value = {};
		Right(value).toOption().get().areEqual(value);
	}

	@Test
	public function should_calling_fold_on_left_should_return_notNull() {
		Left({}).fold(function(value){
				return value;
			}, function(value){
				return value;
			}).isNotNull();
	}

	@Test
	public function should_calling_fold_on_left_should_return_same_instance() {
		var value = {};
		Left(value).fold(function(value){
				return value;
			}, function(value){
				return value;
			}).areEqual(value);
	}

	@Test
	public function should_calling_fold_on_right_should_return_notNull() {
		Right({}).fold(function(value){
				return value;
			}, function(value){
				return value;
			}).isNotNull();
	}

	@Test
	public function should_calling_fold_on_right_should_return_same_instance() {
		var value = {};
		Right(value).fold(function(value){
				return value;
			}, function(value){
				return value;
			}).areEqual(value);
	}

	@Test
    public function should_calling_equals_on_a_Either_left_with_same_instance_isTrue() {
        var instance = Left(true);
        instance.equals(instance).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Either_right_with_same_instance_isTrue() {
        var instance = Right(true);
        instance.equals(instance).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Either_left_with_instance_isTrue() {
        Left(true).equals(Left(true)).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Either_right_with_instance_isTrue() {
        Right(true).equals(Right(true)).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Left_with_Right_isFalse() {
        Left(true).equals(Right(true)).isFalse();
    }

    @Test
    public function should_calling_equals_on_a_Right_with_Left_isFalse() {
        Right(true).equals(Left(true)).isFalse();
    }

    @Test
    public function should_calling_equals_on_a_Right_with_Option_and_Right_with_Option_isTrue() {
        Right(Some(true)).equals(Right(Some(true))).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Right_with_Option_and_Left_with_Option_isFalse() {
        Right(Some(true)).equals(Left(Some(true))).isFalse();
    }

    @Test
    public function should_calling_equals_on_a_Right_with_Option_and_Right_with_Option_value_isFalse() {
        Right(Some(true)).equals(Right(Some(false))).isFalse();
    }

    @Test
    public function should_calling_equals_on_a_Right_with_same_funk_object_isTrue() {
    	var value = {};
        Right(value).equals(Right(value), function(a, b) {
        	return a == b;
        }).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Left_with_same_funk_object_isTrue() {
    	var value = {};
        Left(value).equals(Left(value), function(a, b) {
        	return a == b;
        }).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Right_with_funk_object_isFalse() {
        Right({}).equals(Right({}), function(a, b) {
        	return a == b;
        }).isFalse();
    }

    @Test
    public function should_calling_equals_on_a_Left_with_funk_object_isFalse() {
        Left({}).equals(Left({}), function(a, b) {
        	return a == b;
        }).isFalse();
    }
}