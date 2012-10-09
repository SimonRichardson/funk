package funk.collections.immutable;

import funk.collections.immutable.Nil;

using funk.collections.immutable.Nil;

class ListUtil {

	public static function fill<T>(n : Int, f : (Void -> T)) : IList<T> {
		var l = Nil.list();
		while(--n > -1) {
       		l = l.prepend(f());
       	}
		return l;
	}

	public static function toList<T>(any : T) : IList<T> {
		var l = Nil.list();
		var n : Int;

		if(Std.is(any, IList)) {
			return cast any;

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
