package funk.collections.extensions;

class IteratorsUtil {

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
}
