package funk.collections.immutable;

import funk.Funk;
import funk.collections.IteratorUtil;
import funk.collections.immutable.Nil;
import funk.product.ProductIterator;

using funk.collections.IteratorUtil;
using funk.collections.immutable.Nil;

class ListUtil {

	public static function fill<T>(n : Int, f : Function0<T>) : IList<T> {
		var l = Nil.list();
		while(--n > -1) {
       		l = l.prepend(f());
       	}
		return l.reverse;
	}

	public static function toList<T, E>(any : T) : IList<E> {
		if(Std.is(any, IList)) {
			return cast any;
		} else if(Std.is(any, IProductIterator)) {
			return IteratorUtil.toList(cast any);
		}

		var l = Nil.list();
		var n : Int;

		if(Std.is(any, Array)) {
			var array: Array<E> = cast any;
		    n = array.length;
		    while(--n > -1) {
		    	l = l.prepend(array[n]);
		    }
		} else if(Std.is(any, String)) {
	    	var string: String = cast any;
	    	n = string.length;
	    	while(--n > -1) {
	    		l = l.prepend(cast string.substr(n, 1));
	    	}
	    } else {
			l = l.prepend(cast any);
		}

		return l;
	}

}
