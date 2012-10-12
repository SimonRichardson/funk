package funk.collections;

import funk.collections.IList;
import funk.collections.immutable.ListUtil;
import funk.collections.immutable.Nil;
import funk.errors.AbstractMethodError;
import funk.errors.NoSuchElementError;
import funk.errors.RangeError;
import funk.option.Option;
import massive.munit.Assert;
import massive.munit.AssertExtensions;

using funk.collections.immutable.ListUtil;
using funk.collections.immutable.Nil;
using funk.option.Option;
using massive.munit.Assert;
using massive.munit.AssertExtensions;

class IteratorUtilTest {

	@Test
	public function should_calling_toList_with_iterator_should_return_notNull() {
		new MockIterator(5).toList().isNotNull();
	}

	@Test
	public function should_calling_toList_with_iterator_should_return_a_valid_list() {
		new MockIterator(5).toList().isType(IList);
	}

	@Test
	public function should_calling_toList_with_iterator_should_return_a_nonEmpty_list() {
		new MockIterator(5).toList().nonEmpty.isTrue();
	}

	@Test
	public function should_calling_toList_with_iterator_calling_toString_return_correct_value() {
		IteratorUtil.toInstance(new MockIterator(5)).toList().toString().areEqual("List(0, 1, 2, 3, 4)");
	}

	@Test
	public function should_calling_toList_with_optional_list_calling_toString_return_correct_value() {
		IteratorUtil.toList(new MockIterator(5), Nil.list()).toString().areEqual("List(0, 1, 2, 3, 4)");
	}

	@Test
	public function should_calling_toList_with_a_empty_iterator_should_return_a_valid_list() {
		new MockIterator(0).toList().isType(IList);
	}

	@Test
	public function should_calling_toList_with_a_empty_iterator_should_return_a_isEmpty_list() {
		IteratorUtil.toInstance(new MockIterator(0)).toList().isEmpty.isTrue();
	}
}

private class MockIterator {

	private var _values : Array<Int>;

	public function new(total : Int){
		_values = [];
		for(i in 0...total) {
			_values.push(i);
		}
	}

	public function hasNext() : Bool {
		return _values.length > 0;
	}

	public function next() : Int {
		return _values.shift();
	}
}
