package funk.collections;

import funk.errors.ArgumentError;
import funk.errors.NoSuchElementError;
import funk.option.Any;
import funk.option.Option;
import funk.collections.IMap;
import funk.IFunkObject;
import funk.product.Product;
import funk.product.ProductIterator;
import funk.tuple.Tuple2;

using funk.option.Any;
using funk.option.Option;

class MapIterator<K, V> extends Product, implements IFunkObject, implements IProductIterator<ITuple2<K, V>> {

	private var _map : IMap<K, V>;

	private var _nilMap : IMap<K, V>;

	public function new(l : IMap<K, V>, nilMap : IMap<K, V>) {
		super();

		if(l == null) {
			throw new ArgumentError("List should not be null");
		}
		if(nilMap == null) {
			throw new ArgumentError("NilMap should not be null");
		}

		_map = l;
		_nilMap = nilMap;
	}

	public function hasNext() : Bool {
		return _map.nonEmpty;
	}

	public function next() : ITuple2<K, V> {
		return if(_map == _nilMap) {
			throw new NoSuchElementError();
		} else {
			var head : ITuple2<K, V> = _map.head;
			_map = _map.tail;
			head;
		}
	}

	public function nextOption() : IOption<ITuple2<K, V>> {
		var result : IOption<ITuple2<K, V>> = None.toInstance();
		if(_map != _nilMap) {
			var head : IOption<ITuple2<K, V>> = _map.headOption;
			_map = _map.tail;
			result = head;
		}
		return result;
	}

	override public function equals(that: IFunkObject): Bool {
		return if(this == that) {
			true;
		} else if(Std.is(that, MapIterator)) {
			var thatIterator : MapIterator<Dynamic, Dynamic> = cast that;
			var thatMap : IMap<Dynamic, Dynamic> = cast thatIterator._map;

			if(_map.size == thatMap.size) {
				var result = true;

				for(i in 0..._map.size) {
					var value0 = _map.productElement(i);
					var value1 = thatMap.productElement(i);

					if(Std.is(value0, IFunkObject) && Std.is(value1, IFunkObject)) {
						var funk0 : IFunkObject = cast value0;
						var funk1 : IFunkObject = cast value1;
						result = funk0.equals(funk1);
					} else {
						result = value0 == value1;
					}

					if(!result) {
						break;
					}
				}

				result;
			} else {
				false;
			}
		} else {
			false;
		}
    }

	override public function productElement(index : Int) : Dynamic {
		return _map.productElement(index);
	}

	override private function get_productArity() : Int {
		return _map.size;
	}

	override private function get_productPrefix() : String {
		return "MapIterator";
	}
}
