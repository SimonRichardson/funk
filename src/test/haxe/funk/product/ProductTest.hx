package funk.product;

import funk.errors.AbstractMethodError;
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
