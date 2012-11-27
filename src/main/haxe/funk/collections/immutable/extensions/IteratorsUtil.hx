package funk.collections.immutable.extensions;

import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;

using funk.collections.immutable.extensions.Lists;

class IteratorsUtil {

	public static function toList<T>(iterator : Iterator<T>) : List<T> {
		var list = Nil;
		while(iterator.hasNext()) {
			list = list.prepend(iterator.next());
		}
		return list.reverse();
	}
}
