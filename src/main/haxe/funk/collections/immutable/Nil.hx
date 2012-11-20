package funk.collections.immutable;

import funk.collections.IList;
import funk.collections.IListFactory;
import funk.collections.IMap;
import funk.collections.IMapFactory;
import funk.collections.NilList;
import funk.errors.ArgumentError;
import funk.errors.IllegalOperationError;
import funk.errors.RangeError;
import funk.option.Option;
import funk.tuple.Tuple2;

using funk.collections.IteratorUtil;
using funk.tuple.Tuple2;

enum Collections {
	Nil;
}

class Nils {

	private static var LIST_FACTORY : IListFactory<Dynamic> = new ListFactory<Dynamic>();

	private static var NIL_LIST : IList<Dynamic> = new NilList<Dynamic>(LIST_FACTORY);

	private static var MAP_FACTORY : IMapFactory<Dynamic, Dynamic> = new MapFactory<Dynamic, Dynamic>();

	private static var NIL_MAP : IMap<Dynamic, Dynamic> = new NilMap<Dynamic, Dynamic>(MAP_FACTORY);

	inline public static function list<T>(n : Collections) : IList<T> {
		return cast NIL_LIST;
	}

	inline public static function map<K, V>(m : Collections) : IMap<K, V> {
		return cast NIL_MAP;
	}
}

private class ListFactory<T> implements IListFactory<T> {

	public function new() {
	}

	inline public function createList(value : T, tail : IList<T>) : IList<T> {
		return new List<T>(value, tail);
	}

	inline public function createNilList() : IList<T> {
		return Nils.list(Nil);
	}
}

private class MapFactory<K, V> implements IMapFactory<K, V> {

	public function new() {
	}

	inline public function createMap(value : ITuple2<K, V>, tail : IMap<K, V>) : IMap<K, V> {
		return new Map<K, V>(value, tail);
	}

	inline public function createNilMap() : IMap<K, V> {
		return Nils.map(Nil);
	}
}

