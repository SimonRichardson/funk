package funk.types.extensions;

import funk.collections.Collection;
import funk.collections.extensions.CollectionsUtil;
import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;

using funk.collections.immutable.extensions.Lists;

class Iterators {

	inline public static function reverse<T>(iterator : Iterator<T>) : Iterator<T> {
		var p = iterator;
		var stack = toArray(p);
		stack.reverse();
		return stack.iterator();
	}

	inline public static function toArray<T>(iterator : Iterator<T>) : Array<T> {
		var stack = [];
		var p = iterator;
		for(i in p) {
			stack.push(i);
		}
		return stack;
	}

	inline public static function toCollection<T>(iterator : Iterator<T>) : Collection<T> {
		var p = iterator;
		return CollectionsUtil.toCollection(toArray(p));
	}

	inline public static function toList<T>(iterator : Iterator<T>) : List<T> {
		var p = iterator;
		var list = Nil;
		while(p.hasNext()) {
			list = list.prepend(p.next());
		}
		return list.reverse();
	}
}
