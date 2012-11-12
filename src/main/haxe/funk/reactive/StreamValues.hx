package funk.reactive;

import funk.Funk;
import funk.collections.IList;
import funk.collections.IteratorUtil;
import funk.collections.immutable.ListUtil;
import funk.collections.immutable.Nil;
import funk.errors.ArgumentError;
import funk.errors.NoSuchElementError;
import funk.errors.RangeError;
import funk.IFunkObject;
import funk.product.Product;
import funk.product.ProductIterator;
import funk.option.Any;
import funk.option.Option;
import funk.signal.Signal1;
import funk.tuple.Tuple2;

using funk.collections.IteratorUtil;
using funk.collections.immutable.ListUtil;
using funk.collections.immutable.Nil;
using funk.option.Any;
using funk.option.Option;
using funk.tuple.Tuple2;

class StreamValues<T> extends Product, implements IList<T> {

    public var nonEmpty(get_nonEmpty, never) : Bool;

    public var head(get_head, never) : T;

    public var headOption(get_headOption, never) : IOption<T>;

    public var indices(get_indices, never) : IList<Int>;

    public var init(get_init, never) : IList<T>;

    public var isEmpty(get_isEmpty, never) : Bool;

    public var last(get_last, never) : IOption<T>;

    public var reverse(get_reverse, never) : IList<T>;

    public var tail(get_tail, never) : IList<T>;

    public var tailOption(get_tailOption, never) : IOption<IList<T>>;

    public var zipWithIndex(get_zipWithIndex, never) : IList<ITuple2<T, Int>>;

    public var size(get_size, never) : Int;

    public var hasDefinedSize(get_hasDefinedSize, never) : Bool;

    public var toArray(get_toArray, never) : Array<T>;

    public var flatten(get_flatten, never) : IList<T>;

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

    public function contains(value : T) : Bool {
        return _list.contains(value);
    }

    public function count(f : Function1<T, Bool>) : Int {
        return _list.count(f);
    }

    public function drop(n : Int) : IList<T> {
        var d = _list.drop(n);
        return if (_list == d) {
            this;
        } else {
            var stream = new StreamValues();
            stream._list = d;
            stream;
        }
    }

    public function dropRight(n : Int) : IList<T> {
        var d = _list.dropRight(n);
        return if (_list == d) {
            this;
        } else {
            var stream = new StreamValues();
            stream._list = d;
            stream;
        }
    }

    public function dropWhile(f : Function1<T, Bool>) : IList<T> {
        var stream = new StreamValues();
        stream._list = _list.dropWhile(f);
        return stream;
    }

    public function exists(f : Function1<T, Bool>) : Bool {
        return _list.exists(f);
    }

    public function filter(f : Function1<T, Bool>) : IList<T> {
        var stream = new StreamValues();
        stream._list = _list.filter(f);
        return stream;
    }

    public function filterNot(f : Function1<T, Bool>) : IList<T> {
        var stream = new StreamValues();
        stream._list = _list.filterNot(f);
        return stream;
    }

    public function find(f : Function1<T, Bool>) : IOption<T> {
        return _list.find(f);
    }

    public function flatMap(f : Function1<T, IList<T>>) : IList<T> {
        var stream = new StreamValues();
        stream._list = _list.flatMap(f);
        return stream;
    }

    public function foldLeft(x : T, f : Function2<T, T, T>) : T {
        return _list.foldLeft(x, f);
    }

    public function foldRight(x : T, f : Function2<T, T, T>) : T {
        return _list.foldRight(x, f);
    }

    public function forall(f : Function1<T, Bool>) : Bool {
        return _list.forall(f);
    }

    public function foreach(f : Function1<T, Void>) : Void {
        _list.foreach(f);
    }

    public function get(index : Int) : IOption<T> {
        return _list.get(index);
    }

    public function map<E>(f : Function1<T, E>) : IList<E> {
        var stream = new StreamValues();
        stream._list = _list.map(f);
        return stream;
    }

    public function partition(f : Function1<T, Bool>) : ITuple2<IList<T>, IList<T>> {
        var tuple = _list.partition(f);

        var left = new StreamValues();
        left._list = tuple._1;

        var right = new StreamValues();
        right._list = tuple._2;

        return tuple2(cast left, cast right).toInstance();
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

    public function prepend(value : T) : IList<T> {
        var stream = new StreamValues();
        stream._list = _list.prepend(value);
        return stream;
    }

    public function prependAll(value : IList<T>) : IList<T> {
        var n = value.size;

        if(n == 0) {
            return this;
        }

        var stream = new StreamValues();
        stream._list = _list.prependAll(value);
        return stream;
    }

    public function reduceLeft(f : Function2<T, T, T>) : IOption<T> {
        return _list.reduceLeft(f);
    }

    public function reduceRight(f : Function2<T, T, T>) : IOption<T> {
        return _list.reduceRight(f);
    }

    public function take(n : Int) : IList<T> {
        var stream = new StreamValues();
        stream._list = _list.take(n);
        return stream;
    }

    public function takeRight(n : Int) : IList<T> {
        var stream = new StreamValues();
        stream._list = _list.takeRight(n);
        return stream;
    }

    public function takeWhile(f : Function1<T, Bool>) : IList<T> {
        var stream = new StreamValues();
        stream._list = _list.takeWhile(f);
        return stream;
    }

    public function zip(that : IList<T>) : IList<ITuple2<T, T>> {
        var stream = new StreamValues();
        stream._list = _list.zip(that);
        return stream;
    }

    public function findIndexOf(f: Function1<T, Bool>): Int {
        return _list.findIndexOf(f);
    }

    public function indexOf(value : T) : Int {
        return _list.indexOf(value);
    }

    public function prependIterator(iterator : Iterator<T>) : IList<T> {
        var stream = new StreamValues();
        stream._list = _list.prependIterator(iterator);
        return stream;
    }

    public function prependIterable(iterable : Iterable<T>) : IList<T> {
        var stream = new StreamValues();
        stream._list = _list.prependIterable(iterable);
        return stream;
    }

    public function append(value : T) : IList<T> {
        var stream = new StreamValues();
        stream._list = _list.append(value);
        return stream;
    }

    public function appendAll(value : IList<T>) : IList<T> {
        var stream = new StreamValues();
        stream._list = _list.appendAll(value);
        return stream;
    }

    public function appendIterator(iterator : Iterator<T>) : IList<T> {
        var stream = new StreamValues();
        stream._list = _list.appendIterator(iterator);
        return stream;
    }

    public function appendIterable(iterable : Iterable<T>) : IList<T> {
        var stream = new StreamValues();
        stream._list = _list.appendIterable(iterable);
        return stream;
    }

    override public function productElement(i : Int) : Dynamic {
        return _list.productElement(i);
    }

    override public function productIterator() : IProductIterator<Dynamic> {
        return _list.productIterator();
    }

    public function toList() : IList<T> {
        return _list;
    }

    private function get_nonEmpty() : Bool {
        return _list.nonEmpty;
    }

    public function get_isEmpty() : Bool {
        return _list.isEmpty;
    }

    private function get_head() : T {
        return _list.head;
    }

    private function get_headOption() : IOption<T> {
        return _list.headOption;
    }

    private function get_indices() : IList<Int> {
        return _list.indices;
    }

    private function get_init() : IList<T> {
        return _list.init;
    }

    private function get_last() : IOption<T> {
        return _list.last;
    }

    private function get_reverse() : IList<T> {
        return _list.reverse;
    }

    private function get_tail() : IList<T> {
        return _list.tail;
    }

    private function get_tailOption() : IOption<IList<T>> {
        return _list.tailOption;
    }

    private function get_zipWithIndex() : IList<ITuple2<T, Int>> {
        return _list.zipWithIndex;
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

    private function get_flatten() : IList<T> {
        var stream = new StreamValues();
        stream._list = _list.flatten;
        return stream;
    }

    override private function get_productArity() : Int {
        return _list.size;
    }

    override private function get_productPrefix() : String {
        return "StreamValues";
    }
}
