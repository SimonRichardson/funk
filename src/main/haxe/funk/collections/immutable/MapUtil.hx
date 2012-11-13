package funk.collections.immutable;

import funk.Funk;
import funk.collections.IteratorUtil;
import funk.collections.immutable.Nil;
import funk.product.ProductIterator;
import funk.tuple.Tuple2;

using funk.collections.IteratorUtil;
using funk.collections.immutable.Nil;

class MapUtil {

	public static function fill<K, V>(n : Int, f : Function0<ITuple2<K, V>>) : IMap<K, V> {
		var l = Nil.map();
		while(--n > -1) {
			var func = f();
       		l = l.add(func._1, func._2);
       	}
		return l;
	}

	public static function toMap<T, K, V>(any : T) : IMap<K, V> {
		if(Std.is(any, IMap)) {
			return cast any;
		} else if(Std.is(any, IProductIterator)) {
			return IteratorUtil.toMap(cast any);
		}
		
		var l = Nil.map();
		var n : Int;

		if(Std.is(any, Array)) {
			var array : Array<Dynamic> = cast any;
		    n = array.length;
		    while(--n > -1) {
		    	var item = array[n];
		    	if(Std.is(item, ITuple2)) {
		    		var tuple = cast item;
		    		l = l.add(tuple._1, tuple._2);	
		    	} else {
		    		l = l.add(n, item);
		    	}
		    }
		} else if(Std.is(any, String)) {
	    	var string: String = cast any;
	    	n = string.length;
	    	while(--n > -1) {
	    		l = l.add(n, cast string.substr(n, 1));
	    	}
	    } else {
			l = l.add(0, cast any);
		}

		return cast l;
	}

}
