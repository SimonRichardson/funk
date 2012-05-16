package funk.collections;

import funk.util.Require;
import funk.collections.IList;
import funk.collections.immutable.Nil;

using funk.util.Require;
using funk.collections.immutable.Nil;

class Range {
	
	public static function to(start: Int, end: Int): IList<Int> {
		require("Start must be less than end.").toBe(start < end);

        var m: Int = start - 1;
        var n: Int = end + 1;
        var l: IList<Int> = nil.list();

        while(--n > m) {
            l = l.prepend(n);
        }

        return l;
    }
	
	public static function until(start: Int, end: Int): IList<Int> {
		require("Start must be less than end.").toBe(start < end);
		
		var m: Int = start - 1;
	    var n: Int = end;
	    var l: IList<Int> = nil.list();
	
	    while(--n > m) {
	    	l = l.prepend(n);
	    }
	
	    return l;
    }
}
