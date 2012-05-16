package funk.collections.immutable;

import funk.collections.IList;
import funk.collections.immutable.HashMapNil;
import funk.collections.immutable.ListNil;
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
	
	private static var _nilList : IList<Dynamic> = new ListNil<Dynamic>();
	
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
