package funk.collections;

class ListUtil {
	
	public static function toList<A, B>(any : A) : IList<B> {
		var l : IList<B> = nil.instance();
		var n : Int;
		
		if(Std.is(any, IList)) {
			
			return any;
				
		} else if(Std.is(any, Array)) {
			
			var array: Array = any;
		    n = array.length;
		    while(--n > -1) {
		    	l = l.prepend(array[n]);
		    }
		    return l;
			
		} else if(Std.is(value, String)) {
			
	    	var string: String = any;
	    	n = string.length;
	    	while(--n > -1) {
	    		l = l.prepend(string.substr(n, 1));
	    	}
	    	return l;
	    }
	}
	
}
