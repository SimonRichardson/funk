package funk.product;

import massive.munit.Assert;

using massive.munit.Assert;

class Product3Test {

	@Test
	public function should_creating_new_product_not_be_null() {
		(new Product3()).isNotNull();
	}

	@Test
	public function should_product_be_correct_arity() {
		(new Product3().productArity).areEqual(3);
	}

	@Test
	public function should_product_be_correct_prefix() {
		(new Product3().productPrefix).areEqual("Product3");
	}

}
