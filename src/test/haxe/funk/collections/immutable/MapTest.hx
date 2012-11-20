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
		diffFilledList = convertToMapWithKeys([5, 6, 7, 8], [5, 6, 7, 8]);
	}

	@After
	public function tearDown():Void {
		actual = null;
		expected = null;
		other = null;
		filledList = null;
	}

	override public function generateIntMap(size : Int, ?startValue : Int = 0) : IMap<Int, Int> {
		var count = startValue;
		return size.fill(function() : ITuple2<Int, Int> {
			return tuple2(count, count++).toInstance();
		});
	}

	override public function convertToMap<T, K, V>(any : T) : IMap<K, V> {
		return cast any.toMap();
	}

	override public function convertToMapWithKeys<K, V>(keys : K, values : V) : IMap<K, V> {
		if(Std.is(keys, Array) && Std.is(values, Array)) {
			var map = Nil.map();

			var k : Array<Dynamic> = cast keys;
			var v : Array<Dynamic> = cast values;

			if(k.length != v.length) {
				throw "Invalid length";
			}

			for(i in 0...k.length) {
				map = map.add(k[i], v[i]);
			}

			return map;
		} else {
			throw "Unsupported operation";
		}
	}
}
