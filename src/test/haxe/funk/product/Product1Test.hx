package funk.product;

import massive.munit.Assert;

using massive.munit.Assert;

class Product1Test {

	@Test
	public function should_creating_new_product_not_be_null() {
		(new Product1()).isNotNull();
	}

	@Test
	public function should_product_be_correct_arity() {
		(new Product1().productArity).areEqual(1);
	}

	@Test
	public function should_product_be_correct_prefix() {
		(new Product1().productPrefix).areEqual("Product1");
	}

}
