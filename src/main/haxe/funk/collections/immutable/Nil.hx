package funk.collections.immutable;

import funk.collections.IList;
import funk.collections.immutable.HashMapNil;
import funk.collections.immutable.ListNil;
import funk.errors.RangeError;
import funk.option.Option;
import funk.product.Product1;
import funk.tuple.Tuple2;
import funk.util.Require;

using funk.collections.IteratorUtil;
using funk.tuple.Tuple2;
using funk.util.Require;

enum NilEnum {
	nil;
}

class NilType {
	
	inline public static function list<T>(n : NilEnum) : IList<T> {
		return switch(n) {
			case nil: new ListNil<T>(); 
		}
	}
	
	inline public static function set<K, V>(n : NilEnum) : ISet<K, V> {
		return switch(n) {
			case nil: new HashMapNil<K, V>(); 
		}
	}
	
	inline public static function eq<A, B>(n : NilEnum, value : B) : Bool {
		return switch(n) {
			case nil: if(Std.is(value, IList)) {
				// instance(n).equals(value);
				false;
			} else if(Std.is(value, ISet)) {
				// instance(n).equals(value);
				false;
			} else {
				false;
			}
		}
	}
}
