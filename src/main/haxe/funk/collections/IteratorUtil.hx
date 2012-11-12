package funk.collections;

import funk.collections.immutable.Nil;
import funk.product.ProductIterator;
import funk.tuple.Tuple2;

using funk.collections.immutable.Nil;

class IteratorUtil {

	public static function toList<T>(iter : Iterator<T>, ?optionalList : IList<T>) : IList<T> {
		var l : IList<T> = null != optionalList ? optionalList : Nil.list();

		while(iter.hasNext()) {
			l = l.append(iter.next());
		}

		return l;
	}

	inline public static function toMap<K, V>(iter : Iterator<ITuple2<K, V>>, ?optionalMap : IMap<K, V>) : IMap<K, V> {
		var m : IMap<K, V> = null != optionalMap ? optionalMap : Nil.map();

		while(iter.hasNext()) {
			var t = iter.next();
			m = m.add(t._1, t._2);
		}

		return m;
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
