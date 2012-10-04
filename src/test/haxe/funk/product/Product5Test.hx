package funk.product;

import massive.munit.Assert;

using massive.munit.Assert;

class Product5Test {

	@Test
	public function should_creating_new_product_not_be_null() {
		(new Product5()).isNotNull();
	}

	@Test
	public function should_product_be_correct_arity() {
		(new Product5().productArity).areEqual(5);
	}

	@Test
	public function should_product_be_correct_prefix() {
		(new Product5().productPrefix).areEqual("Product5");
	}

}
