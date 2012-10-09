package funk.collections.immutable;

import funk.collections.IList;
import funk.collections.IListFactory;
import funk.collections.NilList;
import funk.errors.RangeError;
import funk.option.Option;
import funk.tuple.Tuple2;
import funk.util.Require;
import funk.unit.Expect;

using funk.collections.IteratorUtil;
using funk.tuple.Tuple2;
using funk.util.Require;
using funk.unit.Expect;

enum Lists {
	Nil;
}

class Nils {
	
	private static var _listFactory : IListFactory<Dynamic> = new ListFactory<Dynamic>();
	
	private static var _nilList : IList<Dynamic> = new NilList<Dynamic>(_listFactory);
	
	inline public static function list<T>(n : Nils) : IList<T> {
		return switch(n) {
			case Nil: cast _nilList; 
		}
	}
}