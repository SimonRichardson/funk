package funk.collections.immutable;

import funk.collections.ListTestBase;
import funk.collections.immutable.ListUtil;
import funk.collections.immutable.Nil;

import massive.munit.Assert;

using funk.collections.immutable.ListUtil;
using funk.collections.immutable.Nil;

using massive.munit.Assert;

class ListTest extends ListTestBase {

	@Before
	public function setup():Void {
		listClassName = 'List';

		actual = [1, 2, 3, 4].toList();
		expected = [1, 2, 3, 4].toList();
		other = Nil.list();
		filledList = [1, 2, 3, 4].toList();
	}

	@After
	public function tearDown():Void {
		actual = null;
		expected = null;
		other = null;
		filledList = null;
	}

	override public function generateIntList(size : Int) : IList<Int> {
		var count = 0;
		return size.fill(function() : Int {
			return count++;
		});
	}

	override public function convertToList<T, E>(any : T) : IList<E> {
		return cast any.toList();
	}
}
