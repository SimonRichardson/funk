package funk.collections;

import funk.collections.immutable.Nil;
import funk.tuple.Tuple2;
import funk.unit.It;

using funk.collections.immutable.Nil;
using funk.tuple.Tuple2;
using funk.unit.It;

class IteratorUtil {
	
	inline public static function isIterator<T>(a : T) : Bool {
		return Reflect.field(a, "hasNext") && Reflect.field(a, "next"); 
	}
	
	inline public static function eq<A, B>(a : Iterator<A>, b : B) : Bool {
		if(a != null && b != null) {
			if(isIterator(b)) {
				var iter : Iterator<B> = cast b;
				while(true) {
					var aHasNext = a.hasNext();
					var bHasNext = iter.hasNext();
					if(aHasNext && bHasNext) {
						var aNext = a.next();
						var bNext = cast iter.next();
						if(it(aNext).toNotEqual(bNext)) {
							return false;
						}
					} else if(!aHasNext && !bHasNext) {
						break;
					} else {
						return false;
					}
				}
				
				return true;
			}
		}
		return false;
	}
	
	inline public static function toArray<T>(iter : Iterator<T>) : Array<T> {
		var array : Array<T> = [];
		while(iter.hasNext()) {
			array.push(iter.next());
		}
		return array;
	}

	inline public static function toList<T>(iter : Iterator<T>) : IList<T> {
		var l : IList<T> = nil.list();
		while(iter.hasNext()) {
			l = l.prepend(iter.next());
		}
		return l.reverse;
	}

	inline public static function toSet<K, V>(iter : Iterator<ITuple2<K, V>>) : ISet<K, V> {
		var s : ISet<K, V> = nil.set();
		var i : Int = 0;
		while(iter.hasNext()) {
			var t = iter.next();
			s = s.add(t._1, t._2);
			i++;
		}
		return s;
	}
	
	inline public static function toIntSet<V>(iter : Iterator<V>) : ISet<Int, V> {
		var s : ISet<Int, V> = nil.set();
		var i : Int = 0;
		while(iter.hasNext()) {
			s = s.add(i, iter.next());
			i++;
		}
		return s;
	}
}
