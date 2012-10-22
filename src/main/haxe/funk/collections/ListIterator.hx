package funk.collections;

import funk.errors.ArgumentError;
import funk.errors.NoSuchElementError;
import funk.option.Any;
import funk.option.Option;
import funk.collections.IList;
import funk.IFunkObject;
import funk.product.Product;
import funk.product.ProductIterator;

using funk.option.Any;
using funk.option.Option;

class ListIterator<T> extends Product, implements IFunkObject, implements IProductIterator<T> {

	private var _list : IList<T>;

	private var _nilList : IList<T>;

	public function new(l : IList<T>, nilList : IList<T>) {
		super();

		if(l == null) {
			throw new ArgumentError("List should not be null");
		}
		if(nilList == null) {
			throw new ArgumentError("NilList should not be null");
		}

		_list = l;
		_nilList = nilList;
	}

	public function hasNext() : Bool {
		return _list.nonEmpty;
	}

	public function next() : T {
		return if(_list == _nilList) {
			throw new NoSuchElementError();
		} else {
			var head : T = _list.head;
			_list = _list.tail;
			head;
		}
	}

	public function nextOption() : IOption<T> {
		return if(_list == _nilList) {
			None.toInstance();
		} else {
			var head : IOption<T> = _list.headOption;
			_list = _list.tail;
			head;
		}
	}

	override public function equals(that: IFunkObject): Bool {
		return if(this == that) {
			true;
		} else if(Std.is(that, ListIterator)) {
			var thatIterator : ListIterator<Dynamic> = cast that;
			var thatList : IList<Dynamic> = cast thatIterator._list;

			if(_list.size == thatList.size) {
				var result = true;

				for(i in 0..._list.size) {
					var value0 = _list.productElement(i);
					var value1 = thatList.productElement(i);

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
		return _list.productElement(index);
	}

	override private function get_productArity() : Int {
		return _list.size;
	}

	override private function get_productPrefix() : String {
		return "ListIterator";
	}
}
