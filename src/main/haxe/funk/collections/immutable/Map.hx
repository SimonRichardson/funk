package funk.collections.immutable;

import funk.Funk;
import funk.IFunkObject;
import funk.collections.IMap;
import funk.collections.IteratorUtil;
import funk.collections.immutable.Nil;
import funk.errors.ArgumentError;
import funk.errors.NoSuchElementError;
import funk.errors.RangeError;
import funk.product.Product;
import funk.product.ProductIterator;
import funk.option.Any;
import funk.option.Option;
import funk.tuple.Tuple2;

using funk.collections.IteratorUtil;
using funk.collections.immutable.Nil;
using funk.option.Any;
using funk.option.Option;
using funk.tuple.Tuple2;


class Map<K, V> extends Product, implements IMap<K, V> {

	public var head(get_head, never) : ITuple2<K, V>;

    public var headOption(get_headOption, never) : IOption<ITuple2<K, V>>;

	public var tail(get_tail, never) : IMap<K, V>;

    public var tailOption(get_tailOption, never) : IOption<IMap<K, V>>;

	public var nonEmpty(get_nonEmpty, never): Bool;

	public var flatten(get_flatten, never): IMap<K, V>;

	public var hasDefinedSize(get_hasDefinedSize, never) : Bool;

	public var isEmpty(get_isEmpty, never): Bool;

	public var size(get_size, never) : Int;

	public var toArray(get_toArray, never) : Array<ITuple2<K, V>>;

	public var zipWithIndex(get_zipWithIndex, never): IMap<ITuple2<K, V>, Int>;

	private var _head : ITuple2<K, V>;

	private var _tail : IMap<K, V>;

	private var _length : Int;

	private var _lengthKnown : Bool;

	public function new(head : ITuple2<K, V>, tail : IMap<K, V>) {
		super();

		_head = head;
		_tail = tail;

		_length = 0;
		_lengthKnown = false;
	}

	public function contains(value : K) : Bool {
		var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
			if(p.head._1.equals(value)) {
		  		return true;
			}
			p = p.tail;
	  	}

	  	return false;
	}

	public function count(f : Function2<K, V, Bool>) : Int {
		var n: Int = 0;
	  	var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
			if(f(p.head._1, p.head._2)) {
		  		++n;
			}

			p = p.tail;
	  	}

	  	return n;
	}

	public function drop(n : Int) : IMap<K, V> {
		if(n < 0){
			throw new ArgumentError("n must be positive");
		}

	  	var p: IMap<K, V> = this;

	  	for(i in 0...n) {
			if(p.isEmpty) {
		  		return Nil.map();
			}

			p = p.tail;
	  	}

	  	return p;
	}

	public function dropRight(n : Int) : IMap<K, V> {
		if(n < 0){
			throw new ArgumentError("n must be positive");
		}

		if(0 == n) {
			return this;
	  	}

	  	n = size - n;

	  	if(n <= 0) {
			return Nil.map();
	  	}

	  	var buffer = new Array<Map<K, V>>();
	  	var m: Int = n - 1;
	  	var p: IMap<K, V> = this;

	  	for(i in 0...n) {
			buffer[i] = new Map<K, V>(p.head, null);
			p = p.tail;
	  	}

	  	buffer[m]._tail = Nil.map();

		var j : Int = 1;
		for(i in 0...m) {
			buffer[i]._tail = buffer[j];
			j++;
	  	}

	  	return buffer[0];
	}

	public function dropWhile(f : Function2<K, V, Bool>) : IMap<K, V> {
		var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
			if(!f(p.head._1, p.head._2)) {
		  		return p;
			}

			p = p.tail;
	  	}

	  	return Nil.map();
	}

	public function exists(f : Function2<K, V, Bool>) : Bool {
		var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
			if(f(p.head._1, p.head._2)) {
		  		return true;
			}

			p = p.tail;
	  	}

	  	return false;
	}

	public function filter(f : Function2<K, V, Bool>) : IMap<K, V> {
		var p: IMap<K, V> = this;
	  	var q: Map<K, V> = null;
	  	var first: Map<K, V> = null;
	  	var last: Map<K, V> = null;
	  	var allFiltered: Bool = true;

	  	while(p.nonEmpty) {
			if(f(p.head._1, p.head._2)) {
		  		q = new Map<K, V>(p.head, Nil.map());

		  		if(null != last) {
					last._tail = q;
		  		}

		  		if(first == null) {
					first = q;
		  		}

		  		last = q;
			} else {
		  		allFiltered = false;
			}

			p = p.tail;
	  	}

	  	if(allFiltered) {
			return this;
	  	}

	  	return (first == null) ? Nil.map() : first;
	}

	public function filterNot(f : Function2<K, V, Bool>) : IMap<K, V> {
		var p: IMap<K, V> = this;
	  	var q: Map<K, V> = null;
	  	var first: Map<K, V> = null;
	  	var last: Map<K, V> = null;
	  	var allFiltered: Bool = true;

	  	while(p.nonEmpty) {
			if(!f(p.head._1, p.head._2)) {
		  		q = new Map<K, V>(p.head, Nil.map());

		  		if(null != last) {
					last._tail = q;
		  		}

		  		if(null == first) {
					first = q;
		  		}

		  		last = q;
			} else {
		  		allFiltered = false;
			}

			p = p.tail;
	  	}

	  	if(allFiltered) {
			return this;
	  	}

	  	return (first == null) ? Nil.map() : first;
	}

	public function find(f : Function2<K, V, Bool>) : IOption<ITuple2<K, V>> {
		var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
			if(f(p.head._1, p.head._2)) {
		  		return Some(p.head).toInstance();
			}

			p = p.tail;
	  	}

	  	return None.toInstance();
	}

	public function flatMap(f : Function1<ITuple2<K, V>, IMap<K, V>>) : IMap<K, V> {
		var n: Int = size;
	  	var buffer: Array<IMap<K, V>> = new Array<IMap<K, V>>();
	  	var p: IMap<K, V> = this;
	  	var i: Int = 0;

	  	while(p.nonEmpty) {
			// TODO (Simon) We should verify the type.
			buffer[i++] = f(p.head);
			p = p.tail;
	  	}

	  	var s: IMap<K, V> = buffer[--n];

	  	while(--n > -1) {
			s = s.addAll(buffer[n]);
	  	}

	  	return s;
	}

	public function foldLeft(	x : ITuple2<K, V>,
								f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>) : ITuple2<K, V> {
		var value: ITuple2<K, V> = x;
	  	var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
			value = f(value, p.head);
			p = p.tail;
	  	}

	  	return value;
	}

	public function foldRight(	x : ITuple2<K, V>,
								f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>) : ITuple2<K, V> {
		var value: ITuple2<K, V> = x;
	  	var buffer: Array<ITuple2<K, V>> = new Array<ITuple2<K, V>>();

		var p: IMap<K, V> = this;
		while(p.nonEmpty) {
			buffer.push(p.head);
			p = p.tail;
	  	}

		var n : Int = buffer.length;
	  	while(--n > -1) {
			value = f(value, buffer[n]);
	  	}

	  	return value;
	}

	public function forall(f : Function2<K, V, Bool>) : Bool {
		var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
			if(!f(p.head._1, p.head._2)) {
		  		return false;
			}

			p = p.tail;
	  	}

	  	return true;
	}

	public function foreach(f : Function2<K, V, Void>) : Void {
		var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
			f(p.head._1, p.head._2);
			p = p.tail;
	  	}
	}

	public function get(index : Int) : IOption<ITuple2<K, V>> {
		return Some(productElement(index)).toInstance();
	}

	public function map(f : Function1<ITuple2<K, V>, ITuple2<K, V>>) : IMap<K, V> {
		var n: Int = size;
	  	var buffer: Array<Map<K, V>> = new Array<Map<K, V>>();
	  	var m: Int = n - 1;

	  	var p: IMap<K, V> = this;

	  	for(i in 0...n) {
			buffer[i] = new Map<K, V>(f(p.head), null);
			p = p.tail;
	  	}

	  	buffer[m]._tail = Nil.map();

		var j : Int = 1;
		for(i in 0...m) {
			buffer[i]._tail = buffer[j];
			j++;
	  	}

	  	return buffer[0];
	}

	public function partition(f : Function2<K, V, Bool>) : ITuple2<IMap<K, V>, IMap<K, V>> {
		var left: Array<Map<K, V>> = new Array<Map<K, V>>();
	  	var right: Array<Map<K, V>> = new Array<Map<K, V>>();

	  	var i: Int = 0;
	  	var j: Int = 0;
	  	var m: Int = 0;
	  	var o: Int = 0;

	  	var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
			if(f(p.head._1, p.head._2)) {
		  		left[i++] = new Map<K, V>(p.head, Nil.map());
			} else {
		  		right[j++] = new Map<K, V>(p.head, Nil.map());
			}

			p = p.tail;
	  	}

	  	m = i - 1;
	  	o = j - 1;

	  	if(m > 0) {
			j = 1;
			for(i in 0...m) {
		  		left[i]._tail = left[j];
				j++;
			}
	  	}

	  	if(o > 0) {
			j = 1;
			for(i in 0...o) {
		  		right[i]._tail = right[j];
				j++;
			}
	  	}

	  	return tuple2(m > 0 ? left[0] : Nil.map(), o > 0 ? right[0] : Nil.map()).toInstance();
	}

	override public function equals(that: IFunkObject): Bool {
		return if(this == that) {
			true;
		} else if (Std.is(that, IList)) {
			super.equals(that);
		} else {
			false;
		}
	}

	public function add(key : K, value : V) : IMap<K, V> {
		return new Map<K, V>(tuple2(key, value).toInstance(), this);
	}

	public function addAll(value : IMap<K, V>) : IMap<K, V> {
		var n: Int = value.size;

	  	if(0 == n) {
			return this;
	  	}

	  	var buffer: Array<Map<K, V>> = new Array<Map<K, V>>();
	  	var m: Int = n - 1;
	  	var p: IMap<K, V> = value;

	  	for(i in 0...n) {
	  		buffer[i] = new Map<K, V>(p.productElement(i), null);
	  	}

	  	buffer[m]._tail = this;

		var j : Int = 1;
		for(i in 0...m) {
			buffer[i]._tail = buffer[j];
			j++;
	  	}

	  	return buffer[0];
	}

	public function reduceLeft(f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>) : IOption<ITuple2<K, V>> {
		var value: ITuple2<K, V> = head;
	  	var p: IMap<K, V> = tail;

	  	while(p.nonEmpty) {
			value = f(value, p.head);
			p = p.tail;
	  	}

	  	return Some(value).toInstance();
	}

	public function reduceRight(f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>) : IOption<ITuple2<K, V>> {
		var buffer: Array<ITuple2<K, V>> = new Array<ITuple2<K, V>>();

		var p: IMap<K, V> = this;
		while(p.nonEmpty) {
			buffer.push(p.head);
			p = p.tail;
	  	}

	  	var value: ITuple2<K, V> = buffer.pop();
	  	var n: Int = buffer.length;

	  	while(--n > -1) {
			value = f(value, buffer[n]);
	  	}

	  	return Some(value).toInstance();
	}

	public function take(n : Int) : IMap<K, V> {
		if(n < 0){
			throw new ArgumentError("n must be positive");
		}

		if(n > size) {
			return this;
	  	} else if(0 == n) {
			return Nil.map();
	  	}

	  	var buffer: Array<Map<K, V>> = new Array<Map<K, V>>();
	  	var m: Int = n - 1;
	  	var p: IMap<K, V> = this;

	  	for(i in 0...n) {
			buffer[i] = new Map<K, V>(p.head, null);
			p = p.tail;
	  	}

	  	buffer[m]._tail = Nil.map();

		var j : Int = 1;
		for(i in 0...m) {
			buffer[i]._tail = buffer[j];
			j++;
	  	}

	  	return buffer[0];
	}

	public function takeRight(n : Int) : IMap<K, V> {
		if(n < 0){
			throw new ArgumentError("n must be positive");
		}

		if(n > size) {
			return this;
	  	} else if(0 == n) {
			return Nil.map();
	  	}

	  	n = size - n;

	  	if(n <= 0) {
			return this;
	  	}

	  	var p: IMap<K, V> = this;

		for(i in 0...n) {
			p = p.tail;
	  	}

	  	return p;
	}

	public function takeWhile(f : Function1<ITuple2<K, V>, Bool>) : IMap<K, V> {
		var buffer: Array<Map<K, V>> = new Array<Map<K, V>>();
	  	var p: IMap<K, V> = this;
	  	var n: Int = 0;

	  	while(p.nonEmpty) {
			if(f(p.head)) {
		  		buffer[n++] = new Map<K, V>(p.head, null);
		  		p = p.tail;
			} else {
		  		break;
			}
	  	}

	  	var m: Int = n - 1;

	  	if(m < 0) {
			return Nil.map();
	  	}

	  	buffer[m]._tail = Nil.map();

		var j : Int = 1;
		for(i in 0...m) {
			buffer[i]._tail = buffer[j];
			j++;
	  	}

	  	return buffer[0];
	}

	public function zip<K1, V1>(that : IMap<K1, V1>) : IMap<ITuple2<K, V>, ITuple2<K1, V1>> {
		var n: Int = Std.int(Math.min(size, that.size));
	  	var m: Int = n - 1;
	  	var buffer = new Array<Map<ITuple2<K, V>, ITuple2<K1, V1>>>();

	  	var p: IMap<K, V> = this;
		var q: IMap<K1, V1> = that;

		for(i in 0...n) {
			var k = p.productElement(i);
			var v = q.productElement(i);

			buffer[i] = new Map<ITuple2<K, V>, ITuple2<K1, V1>>(tuple2(k, v).toInstance(), null);
	  	}

	  	buffer[m]._tail = Nil.map();

		var j : Int = 1;
		for(i in 0...m) {
			buffer[i]._tail = buffer[j];
			j++;
	  	}

	  	return buffer[0];
	}

	public function addIterator(iterator : Iterator<ITuple2<K, V>>) : IMap<K, V> {
		return addAll(iterator.toMap());
	}

	public function addIterable(iterable : Iterable<ITuple2<K, V>>) : IMap<K, V> {
		return addAll(iterable.iterator().toMap());
	}

	override public function productElement(i : Int) : Dynamic {
		var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
			if(i == 0) {
			  return p.head;
			}

			p = p.tail;
			i -= 1;
	  	}

	  	throw new NoSuchElementError();
	}

	override public function productIterator() : IProductIterator<Dynamic> {
		return new MapIterator<K, V>(this);
	}

	private function get_nonEmpty() : Bool {
		return true;
	}

	public function get_isEmpty() : Bool {
		return false;
	}

	private function get_head() : ITuple2<K, V> {
        return _head;
    }

    private function get_headOption() : IOption<ITuple2<K, V>> {
        return Some(_head).toInstance();
    }

	private function get_tail() : IMap<K, V> {
        return _tail;
    }

    private function get_tailOption() : IOption<IMap<K, V>> {
        return Some(_tail).toInstance();
    }

	private function get_zipWithIndex() : IMap<ITuple2<K, V>, Int> {
		var n: Int = size;
	  	var m: Int = n - 1;
	  	var buffer = new Array<Map<ITuple2<K, V>, Int>>();

	  	var p: IMap<K, V> = this;

		for(i in 0...n) {
			buffer[i] = new Map<ITuple2<K, V>, Int>(tuple2(p.head, i).toInstance(), null);
			p = p.tail;
	  	}

	  	buffer[m]._tail = Nil.map();

		var j : Int = 1;
		for(i in 0...m) {
			buffer[i]._tail = buffer[j];
			j++;
	  	}

	  	return buffer[0];
	}

	private function get_size() : Int {
		if(_lengthKnown) {
			return _length;
	  	}

	  	var p: IMap<K, V> = this;
	  	var length: Int = 0;

	  	while(p.nonEmpty) {
			++length;
			p = p.tail;
	  	}

	  	_length = length;
	  	_lengthKnown = true;

	  	return length;
	}

	private function get_hasDefinedSize() : Bool {
		return true;
	}

	private function get_toArray() : Array<ITuple2<K, V>> {
		var n: Int = size;
	  	var array: Array<ITuple2<K, V>> = new Array<ITuple2<K, V>>();
	  	var p: IMap<K, V> = this;

	 	for(i in 0...n) {
			array[i] = p.head;
			p = p.tail;
	  	}

		return array;
	}

	private function get_flatten() : IMap<K, V> {
		return flatMap(function(x: Dynamic): IMap<K, V> {
			return Std.is(x, IMap) ? cast x : x.toMap();
		});
	}

	override private function get_productArity() : Int {
		return size;
	}

	override private function get_productPrefix() : String {
		return "Map";
	}
}
