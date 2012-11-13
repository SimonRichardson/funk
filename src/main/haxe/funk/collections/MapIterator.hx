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

	private var _size : Int;

	private var _index : Int;

	public function new(l : IMap<K, V>) {
		super();

		if(l == null) {
			throw new ArgumentError("List should not be null");
		}

		_map = l;

		_size = _map.size;
		_index = 0;
	}

	public function hasNext() : Bool {
		return _index < _size;
	}

	public function next() : ITuple2<K, V> {
		return if(_index >= _size) {
			throw new NoSuchElementError();
		} else {
			_map.productElement(_index++);
		}
	}

	public function nextOption() : IOption<ITuple2<K, V>> {
		var result = null;
		if(_index < _size) {
			result = Some(_map.productElement(_index++)).toInstance();
		} else {
			result = None.toInstance();
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
