package funk.collections;

import funk.collections.immutable.Nil;
import funk.product.ProductIterator;

using funk.collections.immutable.Nil;

class IteratorUtil {

	public static function toList<T>(iter : Iterator<T>, ?optionalList : IList<T>) : IList<T> {
		var l : IList<T> = null != optionalList ? optionalList : Nil.list();

		while(iter.hasNext()) {
			l = l.append(iter.next());
		}

		return l;
	}

	public static function toArray<T>(iter : Iterator<T>) : Array<T> {
		var a : Array<T> = [];

		while(iter.hasNext()) {
			a.push(iter.next());
		}

		return a;
	}

	public static function toInstance<T>(iter : Iterator<T>) : IProductIterator<T> {
		return new ProxyProductIterator(iter);
	}
}
