package funk.product;

import massive.munit.Assert;

using massive.munit.Assert;

class ProductTest {

	@Test
	public function should_creating_new_product_not_be_null() {
		(new Product()).isNotNull();
	}

}
