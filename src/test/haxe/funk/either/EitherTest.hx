package funk.either;

import funk.either.Either;
import funk.option.Option;
import funk.errors.NoSuchElementError;
import funk.errors.RangeError;
import massive.munit.Assert;
import util.AssertExtensions;

using funk.either.Either;
using funk.option.Option;
using massive.munit.Assert;
using util.AssertExtensions;

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
	public function should_left_instance_be_isLeft_isTrue() {
		Left(1).toInstance().isLeft().isTrue();
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
	public function should_right_instance_be_isRight_isTrue() {
		Right(1).toInstance().isRight().isTrue();
	}

	@Test
	public function should_creating_left_return_valid_option() {
		var value = {};
		Left(value).left().isType(IOption);
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
	public function should_creating_left_instance_with_instance_return_same_instance() {
		var value = {};
		Left(value).toInstance().left().get().areEqual(value);
	}

	@Test
	public function should_creating_left_calling_right_returns_valid_option() {
		Left({}).right().isType(IOption);
	}

	@Test
	public function should_creating_left_calling_right_returns_none() {
		Left({}).right().isEmpty().isTrue();
	}

	@Test
	public function should_creating_right_return_valid_option() {
		Right({}).right().isType(IOption);
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
	public function should_creating_right_instance_with_instance_return_same_instance() {
		var value = {};
		Right(value).toInstance().right().get().areEqual(value);
	}

	@Test
	public function should_creating_right_calling_right_returns_valid_option() {
		Right({}).left().isType(IOption);
	}

	@Test
	public function should_creating_right_calling_right_returns_none() {
		Right({}).left().isEmpty().isTrue();
	}

	@Test
	public function should_creating_right_and_calling_swap_returns_valid_Either() {
		Right({}).swap().isEnum(Either);
	}

	@Test
	public function should_creating_right_and_calling_swap_returns_left() {
		Right({}).swap().isLeft().isTrue();
	}

	@Test
	public function should_creating_right_instance_and_calling_swap_returns_left() {
		Right({}).toInstance().swap().isLeft().isTrue();
	}

	@Test
	public function should_creating_right_and_calling_swap_returns_origin_instance() {
		var value = {};
		Right(value).swap().left().get().areEqual(value);
	}

	@Test
	public function should_creating_left_and_calling_swap_returns_valid_Either() {
		Left({}).swap().isEnum(Either);
	}

	@Test
	public function should_creating_left_and_calling_swap_returns_right() {
		Left({}).swap().isRight().isTrue();
	}

	@Test
	public function should_creating_left_instance_and_calling_swap_returns_right() {
		Left({}).toInstance().swap().isRight().isTrue();
	}

	@Test
	public function should_creating_left_and_calling_swap_returns_origin_instance() {
		var value = {};
		Left(value).swap().right().get().areEqual(value);
	}

	@Test
	public function should_calling_toInstance_on_left_return_valid_ProductEither() {
		Left({}).toInstance().isType(ProductEither);
	}

	@Test
	public function should_calling_toString_should_return_Left_1() {
		Left(1).toString().areEqual("Left(1)");
	}

	@Test
	public function should_calling_instance_toString_should_return_Left_1() {
		Left(1).toInstance().toString().areEqual("Left(1)");
	}

	@Test
	public function should_calling_toString_should_return_Right_1() {
		Right(1).toString().areEqual("Right(1)");
	}

	@Test
	public function should_calling_instance_toString_should_return_Right_1() {
		Right(1).toInstance().toString().areEqual("Right(1)");
	}

	@Test
	public function should_calling_toOption_on_left_return_valid_Option() {
		Left(1).toOption().isType(IOption);
	}

	@Test
	public function should_calling_toOption_on_left_return_None() {
		Left(1).toOption().isEmpty().isTrue();
	}

	@Test
	public function should_calling_instance_toOption_on_left_return_None() {
		Left(1).toInstance().toOption().isEmpty().isTrue();
	}

	@Test
	public function should_calling_toOption_on_right_return_valid_Option() {
		Right(1).toOption().isType(IOption);
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
	public function should_calling_instance_toOption_on_right_return_Some_value() {
		var value = {};
		Right(value).toInstance().toOption().get().areEqual(value);
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
	public function should_calling_fold_on_left_instance_should_return_same_instance() {
		var value = {};
		Left(value).toInstance().fold(function(value){
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
	public function should_calling_fold_on_right_instance_should_return_same_instance() {
		var value = {};
		Right(value).toInstance().fold(function(value){
				return value;
			}, function(value){
				return value;
			}).areEqual(value);
	}

	@Test
	public function should_calling_left_productIterator_return_notNull() {
		Left({}).productIterator().isNotNull();
	}

	@Test
	public function should_calling_right_productIterator_return_notNull() {
		Right({}).productIterator().isNotNull();
	}

	@Test
	public function should_calling_left_productElement_with_0_should_return_value() {
		var value = {};
		Left(value).toInstance().productElement(0).areEqual(value);
	}

	@Test
	public function should_calling_left_productElement_with_1_should_throw_RangeError() {
		var called = try {
			Left({}).toInstance().productElement(1);
			false;
		} catch(error : RangeError) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function should_calling_right_productElement_with_1_should_throw_RangeError() {
		var called = try {
			Right({}).toInstance().productElement(1);
			false;
		} catch(error : RangeError) {
			true;
		}
		called.isTrue();
	}

	@Test
    public function should_calling_equals_on_a_ProductEither_left_with_same_instance_isTrue() {
        var instance = Left(true).toInstance();
        instance.equals(instance).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_ProductEither_right_with_same_instance_isTrue() {
        var instance = Right(true).toInstance();
        instance.equals(instance).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_ProductEither_left_with_instance_isTrue() {
        Left(true).toInstance().equals(Left(true).toInstance()).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_ProductEither_right_with_instance_isTrue() {
        Right(true).toInstance().equals(Right(true).toInstance()).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Left_with_Right_isFalse() {
        Left(true).toInstance().equals(Right(true).toInstance()).isFalse();
    }

    @Test
    public function should_calling_equals_on_a_Right_with_Left_isFalse() {
        Right(true).toInstance().equals(Left(true).toInstance()).isFalse();
    }

    @Test
    public function should_calling_equals_on_a_Right_with_Option_and_Right_with_Option_isTrue() {
        Right(Some(true).toInstance()).toInstance().equals(Right(Some(true).toInstance()).toInstance()).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Right_with_Option_and_Left_with_Option_isFalse() {
        Right(Some(true).toInstance()).toInstance().equals(Left(Some(true).toInstance()).toInstance()).isFalse();
    }

    @Test
    public function should_calling_equals_on_a_Right_with_Option_and_Right_with_Option_value_isFalse() {
        Right(Some(true).toInstance()).toInstance().equals(Right(Some(false).toInstance()).toInstance()).isFalse();
    }

    @Test
    public function should_calling_equals_on_a_Right_with_same_funk_object_isTrue() {
    	var value = new MockIFunkObject();
        Right(value).toInstance().equals(Right(value).toInstance()).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Left_with_same_funk_object_isTrue() {
    	var value = new MockIFunkObject();
        Left(value).toInstance().equals(Left(value).toInstance()).isTrue();
    }

    @Test
    public function should_calling_equals_on_a_Right_with_funk_object_isFalse() {
        Right(new MockIFunkObject()).toInstance().equals(Right(new MockIFunkObject()).toInstance()).isFalse();
    }

    @Test
    public function should_calling_equals_on_a_Left_with_funk_object_isFalse() {
        Left(new MockIFunkObject()).toInstance().equals(Left(new MockIFunkObject()).toInstance()).isFalse();
    }
}

private class MockIFunkObject implements IFunkObject {

	public function new(){

	}

	public function equals(value : IFunkObject) : Bool {
		return (this == value);
	}

	public function toString() : String {
		return "MockIFunkObject";
	}

}
