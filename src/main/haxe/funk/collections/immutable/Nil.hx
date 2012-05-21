package funk.collections.immutable;

import funk.collections.IList;
import funk.collections.IListFactory;
import funk.collections.immutable.HashMapNil;
import funk.collections.ListNil;
import funk.errors.RangeError;
import funk.option.Option;
import funk.tuple.Tuple2;
import funk.util.Require;
import funk.unit.Expect;

using funk.collections.IteratorUtil;
using funk.tuple.Tuple2;
using funk.util.Require;
using funk.unit.Expect;

enum NilEnum {
	nil;
}

class NilType {
	
	private static var _listFactory : IListFactory<Dynamic> = new ListFactory<Dynamic>();
	
	private static var _nilList : IList<Dynamic> = new ListNil<Dynamic>(_listFactory);
	
	private static var _nilSet : ISet<Dynamic, Dynamic> = new HashMapNil<Dynamic, Dynamic>();
	
	inline public static function list<T>(n : NilEnum) : IList<T> {
		return switch(n) {
			case nil: cast _nilList; 
		}
	}
	
	inline public static function set<K, V>(n : NilEnum) : ISet<K, V> {
		return switch(n) {
			case nil: cast _nilSet; 
		}
	}
	
	inline public static function eq<A, B>(n : NilEnum, value : B) : Bool {
		return switch(n) {
			case nil: if(Std.is(value, IList)) {
				expect(n).toEqual(value);
			} else if(Std.is(value, ISet)) {
				expect(n).toEqual(value);
			} else {
				false;
			}
		}
	}
}

class ListFactory<T> implements IListFactory<T> {
	
	public function new() {
	}
	
	inline public function createList(value : T, tail : IList<T>) : IList<T> {
		return new List<T>(value, tail);
	}
	
	inline public function createNilList() : IList<T> {
		return NilType.list(nil);
	}
}

