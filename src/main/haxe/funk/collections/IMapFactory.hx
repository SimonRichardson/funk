package funk.collections;

import funk.collections.IMap;
import funk.tuple.Tuple2;

interface IMapFactory<K, V> {

	function createMap(key : K, value : V, tail : IMap<K, V>) : IMap<K, V>;

	function createNilMap() : IMap<K, V>;

	function createPair(key : K, value : V) : ITuple2<K, V>;
}
