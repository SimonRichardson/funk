package funk.collections.immutable;

import funk.errors.NoSuchElementError;
import funk.option.Any;
import funk.option.Option;
import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.collections.IteratorUtil;
import funk.FunkObject;
import funk.product.Product;
import funk.product.ProductIterator;
import funk.tuple.Tuple2;

using funk.collections.IteratorUtil;
using funk.collections.immutable.Nil;
using funk.option.Option;
using funk.tuple.Tuple2;

class HashMapIterator<K, V> extends Product, implements IFunkObject, implements IProductIterator<ITuple2<K, V>> {
	
	private var _set : ISet<K, V>;
	
	public function new(l : ISet<K, V>) {
		super();
		
		_set = l;
	}
	
	public function hasNext() : Bool {
		return _set.nonEmpty;
	}
	
	public function next() : ITuple2<K, V> {
		return if(_set == nil.set()) {
			throw new NoSuchElementError();
		} else {
			var head : ITuple2<K, V> = _set.head;
			_set = _set.tail;
			head;
		}
	}
	
	public function nextOption() : Option<ITuple2<K, V>> {
		return if(_set == nil.set()) {
			None;
		} else {
			var head : Option<ITuple2<K, V>> = _set.headOption;
			_set = _set.tail;
			head;
		}
	}
	
	override public function equals(that: IFunkObject): Bool {
      	return IteratorUtil.eq(this, that);
    }
	
	override public function productElement(index : Int) : Dynamic {
		return _set.productElement(index);
	}
	
	override private function get_productArity() : Int {
		return _set.size;
	}

	override private function get_productPrefix() : String {
		return "HashMapIterator";
	}
}

class HashMapIteratorType {
	
	inline public static function toArray<K, V>(iter : HashMapIterator<K, V>) : Array<ITuple2<K, V>> {
		return IteratorUtil.toArray(iter);
	}
	
	inline public static function toList<K, V>(iter : HashMapIterator<K, V>) : IList<ITuple2<K, V>> {
		return IteratorUtil.toList(iter);
	}
}