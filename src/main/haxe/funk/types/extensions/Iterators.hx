package funk.types.extensions;

import funk.collections.Collection;
import funk.collections.CollectionUtil;
import funk.collections.immutable.List;
import funk.collections.immutable.ListUtil;

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

	inline public static function toList<T>(iterator : Iterator<T>) : List<T> {
		return ListUtil.toList(toArray(iterator));
	}
}
