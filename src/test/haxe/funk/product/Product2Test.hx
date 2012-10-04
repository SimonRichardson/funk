package funk.product;

import massive.munit.Assert;

using massive.munit.Assert;

class Product2Test {

	@Test
	public function should_creating_new_product_not_be_null() {
		(new Product2()).isNotNull();
	}

	@Test
	public function should_product_be_correct_arity() {
		(new Product2().productArity).areEqual(2);
	}

	@Test
	public function should_product_be_correct_prefix() {
		(new Product2().productPrefix).areEqual("Product2");
	}
}
