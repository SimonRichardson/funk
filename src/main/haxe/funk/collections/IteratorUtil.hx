package funk.collections;

class IteratorUtil {
	
	inline public static function toArray<T>(iter : IIterator<T>) : Array<T> {
		var array : Array<T> = [];
		while(iter.hasNext) {
			array.push(iter.next());
		}
		return array;
	}

	inline public static function toList<T>(iter : IIterator<T>) : IList<T> {
		var l : IList<T> = nil();
		while(iter.hasNext) {
			l = l.prepend(iter.next());
		}
		return l.reverse;
	}
	
}
