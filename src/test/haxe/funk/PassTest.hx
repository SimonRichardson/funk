package funk;

import funk.Pass;
import funk.collections.IList;
import massive.munit.Assert;

using funk.Pass;
using massive.munit.Assert;

class PassTest {

	@Test
	public function when_calling_any__should_return_value() : Void {
		true.any()().areEqual(true);
	}

	@Test
	public function when_calling_string__should_return_value() : Void {
		"abc".string()().areEqual("abc");
	}

	@Test
	public function when_calling_bool__should_return_value() : Void {
		false.bool()().areEqual(false);
	}

	@Test
	public function when_calling_int__should_return_value() : Void {
		123.int()().areEqual(123);
	}

	@Test
	public function when_calling_float__should_return_value() : Void {
		123.1.float()().areEqual(123.1);
	}

	@Test
	public function when_calling_type__should_return_value() : Void {
		A.type()().areEqual(A);
	}

	@Test
	public function when_calling_instanceOf__should_return_value() : Void {
		A.instanceOf()().isType(A);
	}
}

class A<T> {

	public function new(){

	}

}
