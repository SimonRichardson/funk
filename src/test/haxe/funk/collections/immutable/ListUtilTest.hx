package funk.collections.immutable;

import funk.collections.IList;
import funk.collections.immutable.ListUtil;
import funk.collections.immutable.Nil;
import massive.munit.Assert;
import massive.munit.AssertExtensions;

using funk.collections.immutable.ListUtil;
using funk.collections.immutable.Nil;
using massive.munit.Assert;
using massive.munit.AssertExtensions;

class ListUtilTest {

	@Test
	public function should_calling_fill_with_5_should_return_list_of_5() {
		var increment = 0;
		5.fill(function(){
			return increment++;
		}).size.areEqual(5);
	}

	@Test
	public function should_calling_fill_with_5_should_return_list_with_toString() {
		var increment = 0;
		5.fill(function(){
			return increment++;
		}).toString().areEqual("List(0, 1, 2, 3, 4)");
	}

	@Test
	public function should_calling_toList_with_list_return_same_instance() {
		var instance = 5.fill(function(){
			return 1;
		});

		instance.toList().areEqual(instance);
	}

	@Test
	public function should_calling_toList_with_nil_list_return_same_instance() {
		var instance = Nil.list();
		instance.toList().areEqual(instance);
	}

	@Test
	public function should_calling_toList_with_iterator_return_list() {
		new MockIterator(5).toList().isType(IList);
	}

	@Test
	public function should_calling_toList_with_iterator_return_list_of_size_5() {
		new MockIterator(5).toList().size.areEqual(5);
	}

	@Test
	public function should_calling_toList_with_array_return_list() {
		[0, 1, 2, 3, 4].toList().isType(IList);
	}

	@Test
	public function should_calling_toList_with_array_return_list_of_size_5() {
		[0, 1, 2, 3, 4].toList().size.areEqual(5);
	}

	@Test
	public function should_calling_toList_with_string_return_list() {
		"12345".toList().isType(IList);
	}

	@Test
	public function should_calling_toList_with_string_return_list_of_size_5() {
		"12345".toList().size.areEqual(5);
	}

	@Test
	public function should_calling_toList_with_integer_return_list() {
		12345.toList().isType(IList);
	}

	@Test
	public function should_calling_toList_with_integer_return_list_of_size_1() {
		12345.toList().size.areEqual(1);
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
