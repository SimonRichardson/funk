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
import funk.Wildcard;

using funk.collections.IteratorUtil;
using funk.collections.immutable.Nil;
using funk.option.Any;
using funk.option.Option;
using funk.tuple.Tuple2;
using funk.Wildcard;

class Map<K, V> extends Product, implements IMap<K, V> {

	public var nonEmpty(get_nonEmpty, never): Bool;

	public var flatten(get_flatten, never): IMap<K, V>;

	public var hasDefinedSize(get_hasDefinedSize, never) : Bool;

	public var isEmpty(get_isEmpty, never): Bool;

	public var size(get_size, never) : Int;

	public var toArray(get_toArray, never) : Array<ITuple2<K, V>>;

	public var zipWithIndex(get_zipWithIndex, never): IMap<ITuple2<K, V>, Int>;

	public var keys(get_keys, never) : IList<K>;

    public var values(get_values, never) : IList<V>;

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

	public function containsKey(key : K) : Bool {
		var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			if(head._1.equals(key)) {
		  		return true;
			}
			p = imp._tail;
	  	}

	  	return false;
	}

	public function containsValue(value : V) : Bool {
		var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			if(head._2.equals(value)) {
		  		return true;
			}
			p = imp._tail;
	  	}

	  	return false;
	}

	public function count(f : Function1<ITuple2<K, V>, Bool>) : Int {
		var n: Int = 0;
	  	var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			if(f(head)) {
		  		++n;
			}

			p = imp._tail;
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

			var imp : Map<K, V> = cast p;
			p = imp._tail;
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
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			buffer[i] = new Map<K, V>(head, null);
			p = imp._tail;
	  	}

	  	buffer[m]._tail = Nils.map(Nil);

		var j : Int = 1;
		for(i in 0...m) {
			buffer[i]._tail = buffer[j];
			j++;
	  	}

	  	return buffer[0];
	}

	public function dropWhile(f : Function1<ITuple2<K, V>, Bool>) : IMap<K, V> {
		var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			if(!f(head)) {
		  		return imp;
			}

			p = imp._tail;
	  	}

	  	return Nil.map();
	}

	public function exists(f : Function1<ITuple2<K, V>, Bool>) : Bool {
		var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			if(f(head)) {
		  		return true;
			}

			p = imp._tail;
	  	}

	  	return false;
	}

	public function filter(f : Function1<ITuple2<K, V>, Bool>) : IMap<K, V> {
		var p: IMap<K, V> = this;
	  	var q: Map<K, V> = null;
	  	var first: Map<K, V> = null;
	  	var last: Map<K, V> = null;
	  	var allFiltered: Bool = true;

	  	while(p.nonEmpty) {
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			if(f(head)) {
		  		q = new Map<K, V>(head, Nils.map(Nil));

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

			p = imp._tail;
	  	}

	  	if(allFiltered) {
			return this;
	  	}

	  	return (first == null) ? Nil.map() : first;
	}

	public function filterNot(f : Function1<ITuple2<K, V>, Bool>) : IMap<K, V> {
		var p: IMap<K, V> = this;
	  	var q: Map<K, V> = null;
	  	var first: Map<K, V> = null;
	  	var last: Map<K, V> = null;
	  	var allFiltered: Bool = true;

	  	while(p.nonEmpty) {
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			if(!f(head)) {
		  		q = new Map<K, V>(head, Nils.map(Nil));

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

			p = imp._tail;
	  	}

	  	if(allFiltered) {
			return this;
	  	}

	  	return (first == null) ? Nil.map() : first;
	}

	public function find(f : Function1<ITuple2<K, V>, Bool>) : IOption<ITuple2<K, V>> {
		var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			if(f(head)) {
		  		return Some(head).toInstance();
			}

			p = imp._tail;
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
			var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			buffer[i++] = f(head);
			p = imp._tail;
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
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			value = f(value, head);
			p = imp._tail;
	  	}

	  	return value;
	}

	public function foldRight(	x : ITuple2<K, V>,
								f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>) : ITuple2<K, V> {
		var value: ITuple2<K, V> = x;
	  	var buffer: Array<ITuple2<K, V>> = new Array<ITuple2<K, V>>();

		var p: IMap<K, V> = this;
		while(p.nonEmpty) {
			var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			buffer.push(head);
			p = imp._tail;
	  	}

		var n : Int = buffer.length;
	  	while(--n > -1) {
			value = f(value, buffer[n]);
	  	}

	  	return value;
	}

	public function forall(f : Function1<ITuple2<K, V>, Bool>) : Bool {
		var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			if(!f(head)) {
		  		return false;
			}

			p = imp._tail;
	  	}

	  	return true;
	}

	public function foreach(f : Function1<ITuple2<K, V>, Void>) : Void {
		var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			f(head);

			p = imp._tail;
	  	}
	}

	public function get(key : K) : IOption<ITuple2<K, V>> {
		var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			if(head._1.equals(key)) {
		  		return Some(head).toInstance();
			}

			p = imp._tail;
	  	}

	  	return None.toInstance();
	}

	public function map<K1, V1>(f : Function1<ITuple2<K, V>, ITuple2<K1, V1>>) : IMap<K1, V1> {
		var n: Int = size;
	  	var buffer: Array<Map<K1, V1>> = new Array<Map<K1, V1>>();
	  	var m: Int = n - 1;

	  	var p: IMap<K, V> = this;

	  	for(i in 0...n) {
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			buffer[i] = new Map<K1, V1>(f(head), null);

			p = imp._tail;
	  	}

	  	buffer[m]._tail = Nils.map(Nil);

		var j : Int = 1;
		for(i in 0...m) {
			buffer[i]._tail = buffer[j];
			j++;
	  	}

	  	return buffer[0];
	}

	public function partition(f : Function1<ITuple2<K, V>, Bool>) : ITuple2<IMap<K, V>, IMap<K, V>> {
		var left: Array<Map<K, V>> = new Array<Map<K, V>>();
	  	var right: Array<Map<K, V>> = new Array<Map<K, V>>();

	  	var i: Int = 0;
	  	var j: Int = 0;
	  	var m: Int = 0;
	  	var o: Int = 0;

	  	var p: IMap<K, V> = this;

	  	while(p.nonEmpty) {
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			if(f(head)) {
		  		left[i++] = new Map<K, V>(head, Nils.map(Nil));
			} else {
		  		right[j++] = new Map<K, V>(head, Nils.map(Nil));
			}

			p = imp._tail;
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
		if(this == that) {
			return true;
		} else if (Std.is(that, IMap)) {
			var thatMap : IMap<Dynamic, Dynamic> = cast that;
			if (size != thatMap.size) {
				return false;
			}

			// This is expensive, but required because a map can be in any order.
			var p : IMap<K, V> = this;
			while(p.nonEmpty) {
				var imp : Map<K, V> = cast p;
				var head : ITuple2<K, V> = imp._head;

				var o : Option<ITuple2<Dynamic, Dynamic>> = thatMap.get(head._1).toOption();
				switch(o) {
					case Some(value):
						if(!head._2.equals(value._2)) {
							return false;
						}
					case None:
						return false;
				}

				p = imp._tail;
			}

			return true;
		} else {
			return false;
		}
	}

	public function add(key : K, value : V) : IMap<K, V> {
		return new Map<K, V>(new Pair(key, value), this);
	}

	public function addAll(value : IMap<K, V>) : IMap<K, V> {
		var n: Int = value.size;

	  	if(0 == n) {
			return this;
	  	}

	  	var keys : IList<K> = value.keys;

	  	var buffer: Array<Map<K, V>> = new Array<Map<K, V>>();

	  	var p : IMap<K, V> = this;
	  	while(p.nonEmpty) {
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

	  		var ck : K = head._1;

	  		if (!keys.contains(ck)) {
	  			buffer.push(new Map<K, V>(head, null));
	  		}

			p = imp._tail;
	  	}

	  	var items : Array<ITuple2<K, V>> = value.toArray;
	  	for(i in 0...items.length) {
	  		var item : ITuple2<K, V> = items[i];
	  		buffer.push(new Map<K, V>(item, null));
	  	}

        var m = buffer.length - 1;

	  	buffer[m]._tail = Nils.map(Nil);

		var j : Int = 1;
		for(i in 0...m) {
			buffer[i]._tail = buffer[j];
			j++;
	  	}

	  	return buffer[0];
	}

	public function reduceLeft(f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>) : IOption<ITuple2<K, V>> {
		var value: ITuple2<K, V> = _head;

	  	var p: IMap<K, V> = _tail;
	  	while(p.nonEmpty) {
			var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			value = f(value, head);

			p = imp._tail;
	  	}

	  	return Some(value).toInstance();
	}

	public function reduceRight(f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>) : IOption<ITuple2<K, V>> {
		var buffer: Array<ITuple2<K, V>> = new Array<ITuple2<K, V>>();

		var p: IMap<K, V> = this;
		while(p.nonEmpty) {
			var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			buffer.push(head);

			p = imp._tail;
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
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			buffer[i] = new Map<K, V>(head, null);

			p = imp._tail;
	  	}

	  	buffer[m]._tail = Nils.map(Nil);

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
			var imp : Map<K, V> = cast p;
			p = imp._tail;
	  	}

	  	return p;
	}

	public function takeWhile(f : Function1<ITuple2<K, V>, Bool>) : IMap<K, V> {
		var buffer: Array<Map<K, V>> = new Array<Map<K, V>>();
	  	var p: IMap<K, V> = this;
	  	var n: Int = 0;

	  	while(p.nonEmpty) {
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			if(f(head)) {
		  		buffer[n++] = new Map<K, V>(head, null);
			} else {
		  		break;
			}

			p = imp._tail;
	  	}

	  	var m: Int = n - 1;

	  	if(m < 0) {
			return Nil.map();
	  	}

	  	buffer[m]._tail = Nils.map(Nil);

		var j : Int = 1;
		for(i in 0...m) {
			buffer[i]._tail = buffer[j];
			j++;
	  	}

	  	return buffer[0];
	}

	public function zip<K1, V1>(that : IMap<K1, V1>) : IMap<ITuple2<K, V>, ITuple2<K1, V1>> {
		var n: Int = Std.int(Math.min(size, that.size));

		if(n <= 0) {
            return Nil.map();
        }

	  	var m: Int = n - 1;
	  	var buffer = new Array<Map<ITuple2<K, V>, ITuple2<K1, V1>>>();

	  	var p: Array<ITuple2<K, V>> = this.toArray;
		var q: Array<ITuple2<K1, V1>> = that.toArray;

		for(i in 0...n) {
			buffer[i] = new Map<ITuple2<K, V>, ITuple2<K1, V1>>(new Pair(p[i], q[i]), null);
	  	}

	  	buffer[m]._tail = cast Nil.map();

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
	  		var imp: Map<K, V> = cast p;
	  		var head: ITuple2<K, V> = imp._head;

			if(i == 0) {
			  return head;
			}

			p = imp._tail;
			i -= 1;
	  	}

	  	throw new RangeError();
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

	private function get_zipWithIndex() : IMap<ITuple2<K, V>, Int> {
		var n: Int = size;
	  	var m: Int = n - 1;
	  	var buffer = new Array<Map<ITuple2<K, V>, Int>>();

	  	var p: IMap<K, V> = this;

		for(i in 0...n) {
			var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			buffer[i] = new Map<ITuple2<K, V>, Int>(new Pair(head, i), null);

			p = imp._tail;
	  	}

	  	buffer[m]._tail = cast Nil.map();

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

			var imp : Map<K, V> = cast p;
			p = imp._tail;
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
	 		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			array[i] = head;

			p = imp._tail;
	  	}

		return array;
	}

	private function get_flatten() : IMap<K, V> {
		return flatMap(function(x: ITuple2<K, V>): IMap<K, V> {
			if (Std.is(x._2, Map)) {
				var recursive = null;
				recursive = function(m : Map<K, V>) : Array<ITuple2<K, V>> {
					var array = new Array<ITuple2<K, V>>();

					var p: IMap<K, V> = m;
					while(p.nonEmpty) {
						var imp: Map<K, V> = cast p;
	  					var head: ITuple2<K, V> = imp._head;

						if (Std.is(head._2, IMap)) {
							array = array.concat(recursive(cast head._2));
						} else {
							array.push(head);
						}

						p = imp._tail;
					}

					return array;
				};

				return MapUtil.toMap(recursive(cast x._2));
			} else {
				return MapUtil.toMap(x);
			}
		});
	}

	private function get_keys() : IList<K> {
		var l = Nil.list();

		var p: IMap<K, V> = this;
	  	while(p.nonEmpty) {
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			l = l.append(head._1);

			p = imp._tail;
	  	}

	  	return l;
	}

	private function get_values() : IList<V> {
		var l = Nil.list();

		var p: IMap<K, V> = this;
	  	while(p.nonEmpty) {
	  		var imp : Map<K, V> = cast p;
	  		var head : ITuple2<K, V> = imp._head;

			l = l.append(head._2);

			p = imp._tail;
	  	}

	  	return l;
	}

	override private function get_productArity() : Int {
		return size;
	}

	override private function get_productPrefix() : String {
		return "Map";
	}
}
