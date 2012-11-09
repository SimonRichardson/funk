package funk.collections;

import funk.collections.immutable.ListUtil;
import funk.collections.immutable.Nil;
import funk.errors.AbstractMethodError;
import funk.errors.ArgumentError;
import funk.errors.NoSuchElementError;
import funk.errors.RangeError;
import funk.option.Option;
import massive.munit.Assert;
import util.AssertExtensions;

using funk.collections.immutable.ListUtil;
using funk.collections.immutable.Nil;
using funk.option.Option;
using massive.munit.Assert;
using util.AssertExtensions;

class ListIteratorTest {

	private var iterator : ListIterator<Dynamic>;

	@Before
	public function setup() {
		var list = [1, 2, 3, 4].toList();
		iterator = new ListIterator(list, Nil.list());
	}

	@After
	public function tearDown() {
		iterator = null;
	}

	@Test
	public function passing_null_into_list_iterator_should_throw_error() {
		var called = try {
			new ListIterator(null, Nil.list());
			false;
		} catch (error : ArgumentError) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function passing_null_into_nillist_iterator_should_throw_error() {
		var called = try {
			new ListIterator([].toList(), null);
			false;
		} catch (error : ArgumentError) {
			true;
		}
		called.isTrue();
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
	public function should_calling_next_on_a_nil_list_throws_error() {
		var thatIterator = new ListIterator(Nil.list(), Nil.list());
		var called = try {
			thatIterator.next();
			false;
		} catch(error : NoSuchElementError) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function should_calling_nextOption_on_a_nil_list_returns_option() {
		var thatIterator = new ListIterator(Nil.list(), Nil.list());
		thatIterator.nextOption().isType(IOption);
	}

	@Test
	public function should_calling_nextOption_on_a_nil_list_returns_None() {
		var thatIterator = new ListIterator(Nil.list(), Nil.list());
		thatIterator.nextOption().isEmpty().isTrue();
	}

	@Test
	public function should_calling_hasNext_should_return_false() {
		var thatIterator = new ListIterator(Nil.list(), Nil.list());
		thatIterator.hasNext().isFalse();
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
	public function should_iterating_through_the_iterator_via_nextOption_return_1_2_3() {
		var result = [];
		while(iterator.hasNext()){
			result.push(iterator.nextOption().get());
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
	public function should_calling_equals_with_same_different_instance_is_true() {
		var list = [1, 2, 3, 4].toList();
		var thatIterator = new ListIterator(list, Nil.list());
		iterator.equals(thatIterator).isTrue();
	}

	@Test
	public function should_calling_equals_with_different_instances_with_options_is_true() {
		var list = [Some(1), Some(2), Some(3), Some(4)].toList();
		var iterator0 = new ListIterator(list, Nil.list());
		var iterator1 = new ListIterator(list, Nil.list());
		iterator0.equals(iterator1).isTrue();
	}

	@Test
	public function should_calling_equals_with_different_instances_with_options_instances_is_true() {
		var list = [Some(1).toInstance(), Some(2).toInstance()].toList();
		var iterator0 = new ListIterator(list, Nil.list());
		var iterator1 = new ListIterator(list, Nil.list());
		iterator0.equals(iterator1).isTrue();
	}

	@Test
	public function should_calling_equals_with_different_instances_with_differnt_options_is_false() {
		var list0 = [Some(1), Some(2), Some(3), Some(4)].toList();
		var list1 = [Some(1), Some(7), Some(8), Some(9)].toList();
		var iterator0 = new ListIterator(list0, Nil.list());
		var iterator1 = new ListIterator(list1, Nil.list());
		iterator0.equals(iterator1).isFalse();
	}

	@Test
	public function should_calling_equals_with_different_sizes_with_options_is_false() {
		var list0 = [Some(1), Some(2), Some(3), Some(4)].toList();
		var list1 = [Some(1), Some(2), Some(3)].toList();
		var iterator0 = new ListIterator(list0, Nil.list());
		var iterator1 = new ListIterator(list1, Nil.list());
		iterator0.equals(iterator1).isFalse();
	}

	@Test
	public function should_calling_equals_with_different_funk_object_is_false() {
		iterator.equals(new MockIFunkObject()).isFalse();
	}

	@Test
	public function should_calling_toString_equal_ProductIterator_1_2_3_4() {
		iterator.toString().areEqual("ListIterator(1, 2, 3, 4)");
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
