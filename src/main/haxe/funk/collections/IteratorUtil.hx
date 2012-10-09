package funk.collections;

import funk.collections.immutable.Nil;

using funk.collections.immutable.Nil;

class IteratorUtil {

	public static function toList<T>(iter : Iterator<T>, ?optionalList : IList<T>) : IList<T> {
		var l : IList<T> = null != optionalList ? optionalList : Nil.list();
		while(iter.hasNext()) {
			l = l.prepend(iter.next());
		}
		return l.reverse;
	}
}
