package funk.product;

import funk.errors.AbstractMethodError;
import funk.errors.RangeError;
import massive.munit.Assert;

using massive.munit.Assert;

class ProductTest {

	@Test
	public function should_creating_new_product_not_be_null() {
		(new Product()).isNotNull();
	}

	@Test
	public function should_calling_productArity_throw_error() {
		var called = try {
			var product = new Product();
			product.productArity;
			false;
		} catch(error : AbstractMethodError) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function should_calling_productPrefix_throw_error() {
		var called = try {
			var product = new Product();
			product.productPrefix;
			false;
		} catch(error : AbstractMethodError) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function should_calling_productElement_throw_error() {
		var called = try {
			var product = new Product();
			product.productElement(0);
			false;
		} catch(error : AbstractMethodError) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function should_calling_toString_throw_error() {
		var called = try {
			var product = new Product();
			product.toString();
			false;
		} catch(error : AbstractMethodError) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function should_calling_equals_throw_error() {
		var called = try {
			var product = new Product();
			product.equals(new Product());
			false;
		} catch(error : AbstractMethodError) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function should_calling_equals_on_a_MockProduct_with_MockProduct_should_return_true() {
		new MockProduct(true).equals(new MockProduct(true)).isTrue();
	}

	@Test
	public function should_calling_equals_on_a_MockProduct_with_MockProduct_should_return_false() {
		new MockProduct(true).equals(new MockProduct(false)).isFalse();
	}

	@Test
	public function should_calling_equals_on_a_MockProduct_with_MockIFunkObject_should_return_false() {
		new MockProduct(true).equals(new MockIFunkObject()).isFalse();
	}

	@Test
	public function should_calling_equals_on_a_StackProduct_with_StackProduct_should_return_true() {
		new StackProduct().equals(new StackProduct()).isTrue();
	}

	@Test
	public function should_calling_toString_should_return_MockProduct_true() {
		new MockProduct(true).toString().areEqual("MockProduct(true)");
	}

	@Test
	public function should_calling_toString_should_return_StackProduct_1_2_3() {
		new StackProduct().toString().areEqual("StackProduct(1, 2, 3)");
	}

	@Test
	public function should_calling_toString_should_return_EmptyMockProduct() {
		new EmptyMockProduct().toString().areEqual("EmptyMockProduct");
	}

	@Test
	public function should_calling_productIterator_throw_error() {
		var called = try {
			var product = new Product();
			product.productIterator();
			false;
		} catch(error : AbstractMethodError) {
			true;
		}
		called.isTrue();
	}

}

class MockProduct extends Product {

	private var _value : Bool;

	public function new(value : Bool) {
		super();

		_value = value;
	}

	override public function productElement(index : Int) : Dynamic {
		return if(index == 0) {
			_value; 
		} else {
			throw new RangeError();
			false;
		}
	}

	override private function get_productArity() : Int {
		return 1;
	}

	override private function get_productPrefix() : String {
		return "MockProduct";
	}
}

class StackProduct extends Product {

	private var _value : Array<Int>;

	public function new() {
		super();

		_value = [1,2,3];
	}

	override public function productElement(index : Int) : Dynamic {
		return _value[index];
	}

	override private function get_productArity() : Int {
		return _value.length;
	}

	override private function get_productPrefix() : String {
		return "StackProduct";
	}
}

class EmptyMockProduct extends Product {

	public function new() {
		super();
	}

	override public function productElement(index : Int) : Dynamic {
		return false;
	}

	override private function get_productArity() : Int {
		return 0;
	}

	override private function get_productPrefix() : String {
		return "EmptyMockProduct";
	}
}

class MockIFunkObject implements IFunkObject {

	public function new(){

	}

	public function equals(value : IFunkObject) : Bool {
		return false;
	}
	
	public function toString() : String {
		return "MockIFunkObject";
	}

}
