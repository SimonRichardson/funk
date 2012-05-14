package funk.collections.immutable;

import funk.errors.RangeError;
import funk.product.Product1;
import funk.collections.IList;
import funk.option.Option;
import funk.tuple.Tuple2;
import funk.util.Require;

using funk.tuple.Tuple2;
using funk.util.Require;
using funk.collections.IteratorUtil;

enum NilEnum<T> {
	nil;
}

class NilType {
	
	inline public static function list<T>(n : NilEnum<T>) : IList<T> {
		return switch(n) {
			case nil: new Nil<T>(); 
		}
	}
	
	inline public static function set<T>(n : NilEnum<T>) : ISet<T> {
		return switch(n) {
			case nil: new Nil<T>(); 
		}
	}
	
	inline public static function eq<A, B>(n : NilEnum<A>, value : B) : Bool {
		return switch(n) {
			case nil: if(Std.is(l, IList)) {
				// instance(n).equals(value);
			} else if(Std.is(l, ISet)) {
				// instance(n).equals(value);
			} else {
				false;
			}
		}
	}
}
