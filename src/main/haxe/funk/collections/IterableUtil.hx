package funk.collections;

class IterableUtil {

	public static function toList<T>(iter : Iterable<T>, ?optionalList : IList<T>) : IList<T> {
		return IteratorUtil.toList(iter.iterator(), optionalList);
	}

	public static function toArray<T>(iter : Iterable<T>) : Array<T> {
		return IteratorUtil.toArray(iter.iterator());
	}
}
