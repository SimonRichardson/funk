package funk.collections;

import funk.collections.immutable.Nil;

using funk.collections.immutable.Nil;

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
						// FIXME (Simon) Use util.ne
						var aNext = a.next();
						var bNext = cast iter.next();
						if(aNext != bNext) {
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
		var l : IList<T> = nil.instance();
		while(iter.hasNext()) {
			l = l.prepend(iter.next());
		}
		return l.reverse;
	}
	
	inline public static function toSet<K, V>(iter : Iterator<V>) : IList<K, V> {
		var s : ISet<Int, T> = nil.instance();
		var i : Int = 0;
		while(iter.hasNext()) {
			s = s.add(tuple2(i, iter.next()).instance());
			i++;
		}
		return s;
	}
}
