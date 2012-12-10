package funk.types.extensions;

import funk.collections.Collection;
import funk.collections.extensions.CollectionsUtil;

class Iterators {

	public static function reverse<T>(iterator : Iterator<T>) : Iterator<T> {
		var stack = toArray(iterator);
		stack.reverse();
		return stack.iterator();
	}

	public static function toArray<T>(iterator : Iterator<T>) : Array<T> {
		var stack = [];
		for(i in iterator) {
			stack.push(i);
		}
		return stack;
	}

	public static function toCollection<T>(iterator : Iterator<T>) : Collection<T> {
		return CollectionsUtil.toCollection(toArray(iterator));
	}

}
