package funk.collections.mutable;

import funk.collections.IteratorUtil;
import funk.collections.mutable.Nil;
import funk.product.ProductIterator;

using funk.collections.IteratorUtil;
using funk.collections.mutable.Nil;

class ListUtil {

	public static function fill<T>(n : Int, f : (Void -> T)) : IList<T> {
		var l = Nil.list();
		while(--n > -1) {
       		l = l.prepend(f());
       	}
		return l.reverse;
	}

	public static function toList<T>(any : T) : IList<T> {
		var l = Nil.list();
		var n : Int;

		if(Std.is(any, IList)) {

			return cast any;

		} else if(Std.is(any, IProductIterator)) {

			return IteratorUtil.toList(cast any, l);

		} else if(Std.is(any, Array)) {

			var array: Array<T> = cast any;
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

			l = l.prepend(any);

		}

		return l;
	}

}
