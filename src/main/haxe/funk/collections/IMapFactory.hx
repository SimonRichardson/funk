package funk.collections;

import funk.collections.IMap;
import funk.tuple.Tuple2;

interface IMapFactory<K, V> {

	function createMap(value : ITuple2<K, V>, tail : IMap<K, V>) : IMap<K, V>;

	function createNilMap() : IMap<K, V>;
}
