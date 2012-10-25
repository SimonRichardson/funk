package funk.reactive;

import funk.collections.ICollection;
import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.option.Any;
import funk.option.Option;
import funk.product.Product;
import funk.signal.Signal1;

using funk.collections.immutable.Nil;
using funk.option.Any;

class StreamValues<T> extends Product, implements ICollection<T> {

    public var head(get_head, never): IOption<T>;

    public var last(get_last, never): IOption<T>;

	public var size(get_size, never) : Int;

    public var hasDefinedSize(get_hasDefinedSize, never) : Bool;

    public var toArray(get_toArray, never) : Array<T>;

	private var _list : IList<T>;

	public function new(?signal : Signal1<T> = null) {
		super();

		_list = Nil.list();

        signal.getThen(function(s) {

            s.add(function(value : T){
                _list = _list.append(value);
            });

            return s;
        });
	}

    public function filter(func : T -> Bool) : StreamValues<T> {
        var stream = new StreamValues<T>();
        stream._list = _list.filter(func);
        return stream;
    }

    public function map<E>(func : T -> E) : StreamValues<E> {
        var stream = new StreamValues<E>();
        stream._list = _list.map(func);
        return stream;
    }

    public function get(index : Int) : IOption<T> {
        return _list.get(index);
    }

	override public function equals(that: IFunkObject): Bool {
        return if(this == that) {
            true;
        } else if (Std.is(that, StreamValues)) {
            super.equals(cast that);
        } else if (Std.is(that, IList)) {
        	_list.equals(cast that);
        } else {
            false;
        }
    }

    override public function productElement(i : Int) : Dynamic {
        return _list.productElement(i);
    }

    public function toList() : IList<T> {
        return _list;
    }

    private function get_head() : IOption<T> {
        return _list.headOption;
    }

    private function get_last() : IOption<T> {
        return _list.last;
    }

	private function get_size() : Int {
        return _list.size;
    }

    private function get_hasDefinedSize() : Bool {
        return _list.hasDefinedSize;
    }

    private function get_toArray() : Array<T> {
        return _list.toArray;
    }

    override private function get_productArity() : Int {
        return _list.size;
    }

    override private function get_productPrefix() : String {
        return "StreamValues";
    }
}
