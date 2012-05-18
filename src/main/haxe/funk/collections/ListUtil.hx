package funk.collections;

import funk.collections.immutable.Nil;

using funk.collections.immutable.Nil;

class ListUtil {
	
	public static function toList<A>(any : A) : IList<A> {
		var l = nil.list();
		var n : Int;
		
		if(Std.is(any, IList)) {
			return cast any;
				
		} else if(Std.is(any, Array)) {
			
			var array: Array<A> = cast any;
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
