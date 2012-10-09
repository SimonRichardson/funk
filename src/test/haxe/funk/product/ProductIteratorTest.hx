package funk.product;

import funk.errors.AbstractMethodError;
import funk.errors.RangeError;
import massive.munit.Assert;

using massive.munit.Assert;

class ProductIteratorTest {

	private var iterator : ProductIterator<Dynamic>;

	@Before
	public function setup() {
		iterator = new ProductIterator(new StackProduct());
	}

	@After
	public function tearDown() {
		iterator = null;
	}

	@Test
	public function should_creating_new_iterator_not_be_null() {
		iterator.isNotNull();
	}

	@Test
	public function should_calling_hasNext_return_true() {
		iterator.hasNext().isTrue();
	}

	@Test
	public function should_calling_next_return_isNotNull() {
		iterator.next().isNotNull();
	}

	@Test
	public function should_iterating_through_the_iterator_return_1_2_3() {
		var result = [];
		while(iterator.hasNext()){
			result.push(iterator.next());
		}
		
		for(i in 0...result.length) {
			if(result[i] != i + 1) {
				Assert.fail("failed if called");
			}
		}
	}

	@Test
	public function should_calling_equals_with_same_instance_is_true() {
		iterator.equals(iterator).isTrue();
	}

	@Test
	public function should_calling_equals_with_different_instance_is_true() {
		iterator.equals(new ProductIterator(new StackProduct())).isTrue();
	}

	@Test
	public function should_calling_equals_with_different_funk_object_is_false() {
		iterator.equals(new MockIFunkObject()).isFalse();
	}

	@Test
	public function should_calling_toString_equal_ProductIterator_1_2_3() {
		iterator.toString().areEqual("ProductIterator(1, 2, 3)");
	}
}

private class StackProduct extends Product {

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

private class MockIFunkObject implements IFunkObject {

	public function new(){

	}

	public function equals(value : IFunkObject) : Bool {
		return false;
	}
	
	public function toString() : String {
		return "MockIFunkObject";
	}

}