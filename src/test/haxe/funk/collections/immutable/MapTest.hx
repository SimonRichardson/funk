package funk.collections.immutable;

import funk.collections.MapTestBase;
import funk.collections.immutable.MapUtil;
import funk.collections.immutable.Nil;
import funk.tuple.Tuple2;

import massive.munit.Assert;

using funk.collections.immutable.MapUtil;
using funk.collections.immutable.Nil;
using funk.tuple.Tuple2;

using massive.munit.Assert;

class MapTest extends MapTestBase {

	@Before
	public function setup():Void {
		listClassName = 'Map';

		actual = [1, 2, 3, 4].toMap();
		expected = [1, 2, 3, 4].toMap();
		other = Nil.map();
		filledList = [1, 2, 3, 4].toMap();
		diffFilledList = [5, 6, 7, 8].toMap();
	}

	@After
	public function tearDown():Void {
		actual = null;
		expected = null;
		other = null;
		filledList = null;
	}

	override public function generateIntMap(size : Int) : IMap<Int, Int> {
		var count = 0;
		return size.fill(function() : ITuple2<Int, Int> {
			return tuple2(count, count++).toInstance();
		});
	}

	override public function convertToMap<T, K, V>(any : T) : IMap<K, V> {
		return cast any.toMap();
	}
}
