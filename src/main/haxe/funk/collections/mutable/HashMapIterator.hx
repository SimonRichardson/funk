package funk.collections.mutable;

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

private typedef MutableHashMapNamespace<K, V> = {
	var _keys : IntHash<K>;
	var _values : IntHash<V>;
}


class HashMapIterator<K, V> extends Product, implements IFunkObject, implements IProductIterator<ITuple2<K, V>> {
	
	private var _keys : Array<Int>;
	
	private var _setKeys : IntHash<K>;
	
	private var _setValues : IntHash<V>;
	
	private var _pointer : Int;
	
	private var _set : ISet<K, V>;
	
	public function new(s : ISet<K, V>) {
		super();
		
		var mutable : MutableHashMapNamespace<K, V> = cast s;
		_keys = mutable._keys.keys().toArray();
		
		_setKeys = mutable._keys;
		_setValues = mutable._values;
		
		_pointer = _keys.length - 1;
		
		_set = s;
	}
	
	public function hasNext() : Bool {
		return _pointer >= 0;
	}
	
	public function next() : ITuple2<K, V> {
		return if(_pointer < 0) {
			throw new NoSuchElementError();
		} else {
			var key : Int = _keys[_pointer];
			var k : K = _setKeys.get(key);
			var v : V = _setValues.get(key);
			var head : ITuple2<K, V> = tuple2(k, v).instance();
			_pointer--;
			head;
		}
	}
	
	public function nextOption() : Option<ITuple2<K, V>> {
		return if(_set == nil.set()) {
			None;
		} else {
			var key : Int = _keys[_pointer];
			var k : K = _setKeys.get(key);
			var v : V = _setValues.get(key);
			var head : ITuple2<K, V> = tuple2(k, v).instance();
			_pointer--;
			Some(head);
		}
	}
	
	override public function equals(that: IFunkObject): Bool {
      	return IteratorUtil.eq(this, that);
    }
	
	override public function productElement(index : Int) : Dynamic {
		return _set.productElement(index);
	}
	
	override private function get_productArity() : Int {
		return _keys.length;
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
