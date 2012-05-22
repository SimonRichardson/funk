package funk.collections;

import funk.tuple.Tuple2;

interface ISetFactory<K, V> implements ICollectionFactory<V> {
	
	function createSet(value : ITuple2<K, V>, tail : ISet<K, V>) : ISet<K, V>;
	
	function createNilSet() : ISet<K, V>;
}
