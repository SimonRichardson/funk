package funk;

import funk.Curry;
import massive.munit.Assert;

using funk.Curry;
using massive.munit.Assert;

class CurryTest {

	@Test
	public function when_calling_curry1__should_return_value() : Void {
		curry1(function(value0){
			return value0;
		}).call(1).areEqual(1);
	}

	@Test
	public function when_calling_curry2__should_return_value() : Void {
		curry2(function(value0, value1){
			return value0 + value1;
		}).call(1)(2).areEqual(3);
	}

	@Test
	public function when_calling_curry3__should_return_value() : Void {
		curry3(function(value0, value1, value2){
			return value0 + value1 + value2;
		}).call(1)(2)(3).areEqual(6);
	}

	@Test
	public function when_calling_curry4__should_return_value() : Void {
		curry4(function(value0, value1, value2, value3){
			return value0 + value1 + value2 + value3;
		}).call(1)(2)(3)(4).areEqual(10);
	}

	@Test
	public function when_calling_curry5__should_return_value() : Void {
		curry5(function(value0, value1, value2, value3, value4){
			return value0 + value1 + value2 + value3 + value4;
		}).call(1)(2)(3)(4)(5).areEqual(15);
	}

	@Test
	public function when_calling_curry1_complete__should_return_value() : Void {
		Assert.areEqual(curry1(function(value0){
			return value0;
		}).complete([1]), 1);
	}

	@Test
	public function when_calling_curry2_complete__should_return_value() : Void {
		Assert.areEqual(curry2(function(value0, value1){
			return value0 + value1;
		}).complete([1, 2]), 3);
	}

	@Test
	public function when_calling_curry3_complete__should_return_value() : Void {
		Assert.areEqual(curry3(function(value0, value1, value2){
			return value0 + value1 + value2;
		}).complete([1, 2, 3]), 6);
	}

	@Test
	public function when_calling_curry4_complete__should_return_value() : Void {
		Assert.areEqual(curry4(function(value0, value1, value2, value3){
			return value0 + value1 + value2 + value3;
		}).complete([1, 2, 3, 4]), 10);
	}

	@Test
	public function when_calling_curry5_complete__should_return_value() : Void {
		Assert.areEqual(curry5(function(value0, value1, value2, value3, value4){
			return value0 + value1 + value2 + value3 + value4;
		}).complete([1, 2, 3, 4, 5]), 15);
	}

	@Test
	public function when_calling_curry1_complete__should_return_value_false() : Void {
		Assert.areEqual(curry1(function(value0){
			return false;
		}).complete(), false);
	}

	@Test
	public function when_calling_curry2_complete__should_return_value_false() : Void {
		Assert.areEqual(curry2(function(value0, value1){
			return false;
		}).complete(), false);
	}

	@Test
	public function when_calling_curry3_complete__should_return_value_false() : Void {
		Assert.areEqual(curry3(function(value0, value1, value2){
			return false;
		}).complete(), false);
	}

	@Test
	public function when_calling_curry4_complete__should_return_value_false() : Void {
		Assert.areEqual(curry4(function(value0, value1, value2, value3){
			return false;
		}).complete(), false);
	}

	@Test
	public function when_calling_curry5_complete__should_return_value_false() : Void {
		Assert.areEqual(curry5(function(value0, value1, value2, value3, value4){
			return false;
		}).complete(), false);
	}
}
