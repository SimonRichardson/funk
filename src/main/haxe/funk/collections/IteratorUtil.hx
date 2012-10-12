package funk.collections;

import funk.collections.immutable.Nil;
import funk.product.ProductIterator;

using funk.collections.immutable.Nil;

class IteratorUtil {

	public static function toList<T>(iter : Iterator<T>, ?optionalList : IList<T>) : IList<T> {
		var l : IList<T> = null != optionalList ? optionalList : Nil.list();

		while(iter.hasNext()) {
			l = l.prepend(iter.next());
		}

		return if(l.isEmpty) l; else l.reverse;
	}

	public static function toInstance<T>(iter : Iterator<T>) : IProductIterator<T> {
		return new ProxyProductIterator(iter);
	}
}
