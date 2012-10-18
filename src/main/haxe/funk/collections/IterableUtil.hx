package funk.collections;

class IterableUtil {

	public static function toList<T>(iter : Iterable<T>, ?optionalList : IList<T>) : IList<T> {
		return IteratorUtil.toList(iter.iterator(), optionalList);
	}

	public static function toArray<T>(iter : Iterable<T>) : Array<T> {
		return if(Std.is(iter, Array)) {
			cast iter;
		} else {
			IteratorUtil.toArray(iter.iterator());
		};
	}

	public static function size<T>(iter : Iterable<T>) : Int {
		var total = 0;
		for(item in iter) {
			total++;
		}
		return total;
	}
}
