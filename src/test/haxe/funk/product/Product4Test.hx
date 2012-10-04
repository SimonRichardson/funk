package funk.product;

import massive.munit.Assert;

using massive.munit.Assert;

class Product4Test {

	@Test
	public function should_creating_new_product_not_be_null() {
		(new Product4()).isNotNull();
	}

	@Test
	public function should_product_be_correct_arity() {
		(new Product4().productArity).areEqual(4);
	}

	@Test
	public function should_product_be_correct_prefix() {
		(new Product4().productPrefix).areEqual("Product4");
	}
}
