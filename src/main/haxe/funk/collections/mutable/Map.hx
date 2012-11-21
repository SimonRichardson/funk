package funk.collections.mutable;

import funk.Funk;
import funk.IFunkObject;
import funk.collections.IMap;
import funk.collections.IteratorUtil;
import funk.collections.mutable.Nil;
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
using funk.collections.mutable.Nil;
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

	private var _data : Array<ITuple2<K, V>>;

	public function new() {
		super();

		_data = [];
	}

	public function containsKey(key : K) : Bool {
		var index = _data.length;
		while(--index > -1) {
			if(_data[index]._1.equals(key)) {
				return true;
			}
		}

	  	return false;
	}

	public function containsValue(value : V) : Bool {
		var index = _data.length;
		while(--index > -1) {
			if(_data[index]._2.equals(value)) {
				return true;
			}
		}

	  	return false;
	}

	public function count(f : Function1<ITuple2<K, V>, Bool>) : Int {
		var n: Int = 0;

	  	var index = _data.length;
		while(--index > -1) {
			if(f(_data[index])) {
				n++;
			}
		}

	  	return n;
	}

	public function drop(n : Int) : IMap<K, V> {
		if(n < 0){
			throw new ArgumentError("n must be positive");
		}

		var index = Std.int(Math.min(n, size));

	  	_data.splice(0, index);

	  	return _data.length == 0 ? Nil.map() : this;
	}

	public function dropRight(n : Int) : IMap<K, V> {
		if(n < 0){
			throw new ArgumentError("n must be positive");
		}

		var length = _data.length;
		var index = cast(Math.max(0, _data.length - n)) | 0;

	  	_data.splice(0, length);

	  	return this;
	}

	public function dropWhile(f : Function1<ITuple2<K, V>, Bool>) : IMap<K, V> {
		var total = _data.length;
		var index = total;
		for(i in 0...total) {
			if(!f(_data[i])) {
				break;
			}
			index--;
		}

	  	_data.splice(0, (_data.length - 1) - index);

	  	return this;
	}

	public function exists(f : Function1<ITuple2<K, V>, Bool>) : Bool {
		var total : Int = _data.length;
		for(i in 0...total) {
			if(f(_data[i])) {
				return true;
			}
		}

	  	return false;
	}

	public function filter(f : Function1<ITuple2<K, V>, Bool>) : IMap<K, V> {
		var total : Int = _data.length;
		var q : Array<Int> = new Array<Int>();
		for(i in 0...total) {
			if(!f(_data[i])) {
				q.push(i);
			}
		}

		var index = q.length;
		while(--index > -1) {
			_data.splice(q[index], 1);
		}

		return this;
	}

	public function filterNot(f : Function1<ITuple2<K, V>, Bool>) : IMap<K, V> {
		var total : Int = _data.length;
		var q : Array<Int> = new Array<Int>();
		for(i in 0...total) {
			if(f(_data[i])) {
				q.push(i);
			}
		}

		var index = q.length;
		while(--index > -1) {
			_data.splice(q[index], 1);
		}

		return this;
	}

	public function find(f : Function1<ITuple2<K, V>, Bool>) : IOption<ITuple2<K, V>> {
		var total : Int = _data.length;
		for(i in 0...total) {
			var head = _data[i];
			if(f(head)) {
				return Some(head).toInstance();
			}
		}

      	return None.toInstance();
	}

	public function flatMap(f : Function1<ITuple2<K, V>, IMap<K, V>>) : IMap<K, V> {
		var total : Int = _data.length;
		var buffer: Array<IMap<K, V>> = [];
		for(i in 0...total) {
			buffer.push(f(_data[i]));
		}

		_data.splice(0, _data.length);

		var n = buffer.length;
      	while(--n > -1) {
			addAll(buffer[n]);
      	}

		return this;
	}

	public function foldLeft(	x : ITuple2<K, V>,
								f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>) : ITuple2<K, V> {
		var value : ITuple2<K, V> = x;
		var total : Int = _data.length;
		for(i in 0...total) {
			value = f(value, _data[i]);
		}
		return value;
	}

	public function foldRight(	x : ITuple2<K, V>,
								f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>) : ITuple2<K, V> {
		var value : ITuple2<K, V> = x;
		var index : Int = _data.length;
		while(--index > -1) {
			value = f(value, _data[index]);
		}
		return value;
	}

	public function forall(f : Function1<ITuple2<K, V>, Bool>) : Bool {
		var total : Int = _data.length;
		for(i in 0...total) {
			if(!f(_data[i])) {
				return false;
			}
		}

		return true;
	}

	public function foreach(f : Function1<ITuple2<K, V>, Void>) : Void {
		var total : Int = _data.length;
		for(i in 0...total) {
			f(_data[i]);
		}
	}

	public function get(key : K) : IOption<ITuple2<K, V>> {
		var total : Int = _data.length;
		for(i in 0...total) {
			var head : ITuple2<K, V> = _data[i];
			if(head._1.equals(key)) {
				return Some(head).toInstance();
			}
		}

	  	return None.toInstance();
	}

	public function map<K1, V1>(f : Function1<ITuple2<K, V>, ITuple2<K1, V1>>) : IMap<K1, V1> {
		var m: Map<K1, V1> = new Map<K1, V1>();

		var total : Int = _data.length;
		for(i in 0...total) {
			m._data[i] = f(_data[i]);
		}

		return m;
	}

	public function partition(f : Function1<ITuple2<K, V>, Bool>) : ITuple2<IMap<K, V>, IMap<K, V>> {
		var left: Map<K, V> = new Map<K, V>();
      	var right: Map<K, V> = new Map<K, V>();

		var total : Int = _data.length;
		for(i in 0...total) {
			var item = _data[i];
			if(f(item)) {
				left._data.push(item);
			} else {
				right._data.push(item);
			}
		}

		return tuple2(	left.size > 0 ? left : Nil.map(),
						right.size > 0 ? right : Nil.map()
						).toInstance();
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
			var index = _data.length;
			while(--index > -1) {
				var head : ITuple2<K, V> = _data[index];

				var o : Option<ITuple2<Dynamic, Dynamic>> = thatMap.get(head._1).toOption();
				switch(o) {
					case Some(value):
						if(!head._2.equals(value._2)) {
							return false;
						}
					case None:
						return false;
				}
			}

			return true;
		} else {
			return false;
		}
	}

	public function add(key : K, value : V) : IMap<K, V> {
		_data.push(new Pair(key, value));
		return this;
	}

	public function addAll(value : IMap<K, V>) : IMap<K, V> {
		var n: Int = value.size;

	  	if(0 == n) {
			return this;
	  	}

	  	var keys : IList<K> = value.keys;

	  	var buffer: Array<ITuple2<K, V>> = new Array<ITuple2<K, V>>();

	  	var index = _data.length;
	  	while(--index > -1) {
	  		var head : ITuple2<K, V> = _data[index];
	  		var ck : K = head._1;

	  		if (!keys.contains(ck)) {
	  			buffer.push(head);
	  		}
	  	}

	  	var items : Array<ITuple2<K, V>> = value.toArray;
	  	for(i in 0...items.length) {
	  		var item : ITuple2<K, V> = items[i];
	  		buffer.push(item);
	  	}

	  	_data = buffer;

	  	return this;
	}

	public function reduceLeft(	f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>
								) : IOption<ITuple2<K, V>> {
		var index : Int = _data.length - 1;
		var value : ITuple2<K, V> = _data[index];
		while(--index > -1) {
			value = f(value, _data[index]);
		}
		return Some(value).toInstance();
	}

	public function reduceRight(	f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>
									) : IOption<ITuple2<K, V>> {
		var value : ITuple2<K, V> = _data[0];
		var total : Int = _data.length;
		for(i in 1...total) {
			value = f(value, _data[i]);
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

		var t = Std.int(Math.min(n, size));
		_data = _data.splice(_data.length - t, t);

      	return this;
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

		var t = Std.int(Math.min(n, size));
		_data = _data.splice(0, t);

      	return this;
	}

	public function takeWhile(f : Function1<ITuple2<K, V>, Bool>) : IMap<K, V> {
		var buffer:Array<ITuple2<K, V>> = new Array<ITuple2<K, V>>();
		for(i in 0..._data.length) {
			var item : ITuple2<K, V> = _data[i];
			if(f(item)) {
				buffer.push(item);
			} else {
				break;
			}
		}

		if(buffer.length == 0) {
			return Nil.map();
		}

		_data = buffer;

		return this;
	}

	public function zip<K1, V1>(that : IMap<K1, V1>) : IMap<ITuple2<K, V>, ITuple2<K1, V1>> {
		var n: Int = Std.int(Math.min(size, that.size));

		if(n <= 0) {
            return Nil.map();
        }

	  	var m: Int = n - 1;
	  	var map : Map<ITuple2<K, V>, ITuple2<K1, V1>> = new Map<ITuple2<K, V>, ITuple2<K1, V1>>();

	  	var p: Array<ITuple2<K, V>> = this.toArray;
		var q: Array<ITuple2<K1, V1>> = that.toArray;

		for(i in 0...n) {
			map._data[i] = new Pair(p[i], q[i]);
	  	}

	  	return map;
	}

	public function addIterator(iterator : Iterator<ITuple2<K, V>>) : IMap<K, V> {
		return addAll(iterator.toMap());
	}

	public function addIterable(iterable : Iterable<ITuple2<K, V>>) : IMap<K, V> {
		return addAll(iterable.iterator().toMap());
	}

	override public function productElement(i : Int) : Dynamic {
		if(i >= 0 && i < size) {
			return _data[(size - 1) - i];
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
	  	var buffer = new Map<ITuple2<K, V>, Int>();

		for(i in 0...n) {
	  		var head : ITuple2<K, V> = _data[i];
			buffer._data[i] = new Pair(head, i);
	  	}

	  	return buffer;
	}

	private function get_size() : Int {
	  	return _data.length;
	}

	private function get_hasDefinedSize() : Bool {
		return true;
	}

	private function get_toArray() : Array<ITuple2<K, V>> {
		var data = _data.slice(0, _data.length);
		data.reverse();
		return data;
	}

	private function get_flatten() : IMap<K, V> {
		return flatMap(function(x: ITuple2<K, V>): IMap<K, V> {
			if (Std.is(x._2, Map)) {
				var recursive = null;
				recursive = function(m : Map<K, V>) : Array<ITuple2<K, V>> {
					var array = new Array<ITuple2<K, V>>();

					var index = m._data.length;
					while(--index > -1) {
	  					var head: ITuple2<K, V> = m._data[index];

						if (Std.is(head._2, IMap)) {
							array = array.concat(recursive(cast head._2));
						} else {
							array.push(head);
						}
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

		var index = _data.length;
	  	while(--index > -1) {
	  		var head : ITuple2<K, V> = _data[index];
			l = l.append(head._1);
	  	}

	  	return l;
	}

	private function get_values() : IList<V> {
		var l = Nil.list();

		var index = _data.length;
	  	while(--index > -1) {
	  		var head : ITuple2<K, V> = _data[index];
			l = l.append(head._2);
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
