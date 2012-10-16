package funk.collections.mutable;

import funk.collections.IList;
import funk.collections.IListFactory;
import funk.collections.NilList;
import funk.errors.RangeError;
import funk.option.Option;
import funk.tuple.Tuple2;

using funk.collections.IteratorUtil;
using funk.tuple.Tuple2;

enum Lists {
	Nil;
}

class Nils {

	private static var LIST_FACTORY : IListFactory<Dynamic> = new ListFactory<Dynamic>();

	private static var NIL_LIST : IList<Dynamic> = new NilList<Dynamic>(LIST_FACTORY);

	inline public static function list<T>(n : Lists) : IList<T> {
		return switch(n) {
			case Nil: cast NIL_LIST;
		}
	}
}

private class ListFactory<T> implements IListFactory<T> {

	public function new() {
	}

	inline public function createList(value : T, tail : IList<T>) : IList<T> {
		return new List<T>().prepend(value);
	}

	inline public function createNilList() : IList<T> {
		return Nils.list(Nil);
	}

	inline public function createNil() : ICollection<T> {
		return Nils.list(Nil);
	}
}
