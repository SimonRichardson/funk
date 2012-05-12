package funk.collections;

import funk.util.Require;
import funk.collections.IList;
import funk.collections.immutable.Nil;

using funk.util.Require;

class Range {
	
	public static function to<T>(start: Int, end: Int): IList<T> {
		require("Start must be less than end.").toBe(start < end);

        var m: Int = start - 1;
        var n: Int = end + 1
        var l: IList<T> = nil();

        while(--n > m) {
            l = l.prepend(n);
        }

        return l;
    }
	
	public static function until(start: Int, end: Int): IList {
		require("Start must be less than end.").toBe(start < end);
		
		var m: int = start - 1;
	    var n: int = end;
	    var l: IList<T> = nil();
	
	    while(--n > m) {
	    	l = l.prepend(n);
	    }
	
	    return l;
    }
}
