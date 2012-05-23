package funk.collections.mutable;

import funk.collections.IteratorUtil;
import funk.collections.immutable.Nil;
import funk.errors.NoSuchElementError;
import funk.errors.RangeError;
import funk.FunkObject;
import funk.product.Product;
import funk.option.Option;
import funk.tuple.Tuple2;
import funk.unit.Expect;
import funk.util.Require;

using funk.collections.IteratorUtil;
using funk.collections.immutable.Nil;
using funk.option.Option;
using funk.tuple.Tuple2;
using funk.unit.Expect;
using funk.util.Require;

class HashMap<K, V> extends Product, implements ISet<K, V> {
	
	public var nonEmpty(get_nonEmpty, never): Bool;
	
    public var flatten(get_flatten, never): ISet<K, V>;
	
	public var hasDefinedSize(get_hasDefinedSize, never) : Bool;
	
    public var head(get_head, never): ITuple2<K, V>;

	public var headOption(get_headOption, never): Option<ITuple2<K, V>>;

    public var init(get_init, never): ISet<K, V>;

    public var isEmpty(get_isEmpty, never): Bool;

    public var last(get_last, never): Option<ITuple2<K, V>>;
	
	public var size(get_size, never) : Int;
	
    public var tail(get_tail, never): ISet<K, V>;
	
	public var tailOption(get_tailOption, never): Option<ISet<K, V>>;
	
	public var toArray(get_toArray, never) : Array<V>;
	
	public var zipWithIndex(get_zipWithIndex, never): ISet<ITuple2<K, V>, Int>;
	
	private var _keys : IntHash<K>;
	
	private var _values : IntHash<V>;
	
	private var _length : Int;
		
	public function new() {
		super();
		
		_keys = new IntHash<K>();
		_values = new IntHash<V>();
		
		_length = 0;
	}
	
	public function contains(value : K) : Bool {
		for(i in _keys) {
			if(i == value) {
				return true;
			}
		}
		return false;
	}
	
	public function count(f : (K -> V -> Bool)) : Int {
		var n: Int = 0;
		var keys : Iterator<Int> = _keys.keys();
		for(i in keys) {
			if(f(_keys.get(i), _values.get(i))) {
				n++;
			}
		}
      	return n;
	}
	
	public function drop(n : Int) : ISet<K, V> {
		require("n must be positive.").toBe(n >= 0);

		var keys : Iterator<Int> = _keys.keys();
		for(i in keys) {
			if(n == 0) {
				break;
			}
			_keys.remove(i);
			_values.remove(i);
			
			n -= 1;
			_length -= 1;
		}

      	return this;
	}
	
	public function dropRight(n : Int) : ISet<K, V> {
		require("n must be positive.").toBe(n >= 0);
		
		if(0 == n) {
			return this;
      	}
     	
		var keys : Array<Int> = _keys.keys().toArray();
		keys.reverse();
		
		for(i in keys) {
			if(n == 0) {
				break;
			}
			_keys.remove(i);
			_values.remove(i);
			
			n -= 1;
			_length -= 1;
		}

		return this;
	}
	
	public function dropWhile(f : (K -> V -> Bool)) : ISet<K, V> {
		var keys : Iterator<Int> = _keys.keys();
		for(i in keys) {
			if(f(_keys.get(i), _values.get(i))) {
				_keys.remove(i);
				_values.remove(i);
				
				_length -= 1;
			} else {
				break;
			}
		}
	    return this;
	}
	
	public function exists(f : (K -> V -> Bool)) : Bool {
		var keys : Iterator<Int> = _keys.keys();
		for(i in keys) {
			if(f(_keys.get(i), _values.get(i))) {
				return true;
			}
		}
      	return false;
	}
	
	public function filter(f : (K -> V -> Bool)) : ISet<K, V> {
		var keys : Iterator<Int> = _keys.keys();
		for(i in keys) {
			var k : K = _keys.get(i);
			var v : V = _values.get(i);
			
			if(!f(k, v)) {
				_keys.remove(i);
				_values.remove(i);
				
				_length -= 1;
			}
		}
		return this;
	}
	
	public function filterNot(f : (K -> V -> Bool)) : ISet<K, V> {
		var keys : Iterator<Int> = _keys.keys();
		for(i in keys) {
			var k : K = _keys.get(i);
			var v : V = _values.get(i);
			
			if(f(k, v)) {
				_keys.remove(i);
				_values.remove(i);
				
				_length -= 1;
			}
		}
		return this;
	}
	
	public function find(f : (K -> V -> Bool)) : Option<ITuple2<K, V>> {
		var keys : Iterator<Int> = _keys.keys();
		for(i in keys) {
			var k : K = _keys.get(i);
			var v : V = _values.get(i);
			if(f(k, v)) {
				return Some(tuple2(k, v).instance());
			}
		}
      	return None;
	}
	
	public function flatMap(f : (ITuple2<K, V> -> ISet<K, V>)) : ISet<K, V> {
		var buffer: Array<ISet<K, V>> = new Array<ISet<K, V>>();
		var keys : Iterator<Int> = _keys.keys();
		var c : Int = 0;
		for(i in keys) {
			buffer[c++] = f(tuple2(_keys.get(i), _values.get(i)).instance());
		}
		
		_keys = new IntHash<K>();
		_values = new IntHash<V>();
		
		_length = 0;
		
		var n : Int = buffer.length;
      	while(--n > -1) {
        	addAll(buffer[n]);
      	}
		
      	return this;
	}
	
	public function foldLeft(x : ITuple2<K, V>, f : (ITuple2<K, V> -> ITuple2<K, V> -> ITuple2<K, V>)) : ITuple2<K, V> {
		var value: ITuple2<K, V> = x;
      	var p: ISet<K, V> = this;

		var keys : Iterator<Int> = _keys.keys();
		for(i in keys) {
			value = f(value, tuple2(_keys.get(i), _values.get(i)).instance());
		}

      	return value;
	}
	
	public function foldRight(x : ITuple2<K, V>, f : (ITuple2<K, V> -> ITuple2<K, V> -> ITuple2<K, V>)) : ITuple2<K, V> {
		var value: ITuple2<K, V> = x;
      	var p: ISet<K, V> = this;

		var keys : Array<Int> = _keys.keys().toArray();
		keys.reverse();
		
		for(i in keys) {
			value = f(value, tuple2(_keys.get(i), _values.get(i)).instance());
		}

      	return value;
	}
	
	public function forall(f : (K -> V -> Bool)) : Bool {
		var keys : Iterator<Int> = _keys.keys();
		for(i in keys) {
			if(!f(_keys.get(i), _values.get(i))) {
				return false;
			}
		}
      	return true;
	}
	
	public function foreach(f : (K -> V -> Void)) : Void {
		var keys : Iterator<Int> = _keys.keys();
		for(i in keys) {
			f(_keys.get(i), _values.get(i));
		}
	}
	
	public function get(index : Int) : Option<ITuple2<K, V>> {
		return Some(productElement(index));
	}
	
	public function map(f : (ITuple2<K, V> -> ITuple2<K, V>)) : ISet<K, V> {
		var keys : Iterator<Int> = _keys.keys();
		for(i in keys) {
			var t : ITuple2<K,V> = f(tuple2(_keys.get(i), _values.get(i)).instance());
			_keys.set(i, t._1);
			_values.set(i, t._2);
		}
		return this;
	}
	
	public function partition(f : (K -> V -> Bool)) : ITuple2<ISet<K, V>, ISet<K, V>> {
		var left : HashMap<K, V> = new HashMap<K, V>();
		var right : HashMap<K, V> = new HashMap<K, V>();
		
		var keys : Iterator<Int> = _keys.keys();
		for(i in keys) {
			var k : K = _keys.get(i);
			var v : V = _values.get(i);
			if(f(k, v)) {
				left._keys.set(left._length, k);
				left._values.set(left._length, v);
				left._length++;
			} else {
				right._keys.set(right._length, k);
				right._values.set(right._length, v);
				right._length++;
			}
		}
		
      	return tuple2(left.size == 0 ? nil.set() : left, right.size == 0 ? nil.set() : right).instance();
	}
	
	override public function equals(that: IFunkObject): Bool {
      	return if (Std.is(that, ISet)) {
       		super.equals(that);
      	} else {
			false;
		}
    }
	
	public function add(key : K, value : V) : ISet<K, V> {
		_keys.set(_length, key);
		_values.set(_length, value);
		
		_length++;
		
		return this;
	}
	
	public function addAll(value : ISet<K, V>) : ISet<K, V> {
		var n: Int = value.size;

      	if(0 == n) {
        	return this;
      	}
		
		var n : Int = value.size;
		for(i in 0...n) {
			switch(value.get(i)) {
				case None:
				case Some(x):
					_keys.set(_length, x._1);
					_values.set(_length, x._2);
					_length++;		 
			}
		}
		
		return this;
	}
	
	public function reduceLeft(f : (ITuple2<K, V> -> ITuple2<K, V> -> ITuple2<K, V>)) : Option<ITuple2<K, V>> {
		var keys : Array<Int> = _keys.keys().toArray();
		var key : Int = keys.shift();
		
		var value: ITuple2<K, V> = tuple2(_keys.get(key), _values.get(key)).instance();
		for(i in keys) {
			value = f(value, tuple2(_keys.get(i), _values.get(i)).instance());
		}

      	return Some(value);
	}
	
	public function reduceRight(f : (ITuple2<K, V> -> ITuple2<K, V> -> ITuple2<K, V>)) : Option<ITuple2<K, V>> {
		var keys : Array<Int> = _keys.keys().toArray();
		keys.reverse();
		
		var key : Int = keys.shift();
		
		var value: ITuple2<K, V> = tuple2(_keys.get(key), _values.get(key)).instance();
		for(i in keys) {
			value = f(value, tuple2(_keys.get(i), _values.get(i)).instance());
		}

      	return Some(value);
	}
	
	public function take(n : Int) : ISet<K, V> {
		require("n must be positive.").toBe(n >= 0);
		
		if(n > size) {
        	return this;
      	} else if(0 == n) {
        	return this;
      	}
		
		var keys : Array<Int> = _keys.keys().toArray();
		keys.reverse();
		
		var index : Int = size - n;
		while(--index > -1) {
			_keys.remove(keys[index]);
			_values.remove(keys[index]);
			_length--;
		}
			
      	return this;
	}
	
	public function takeRight(n : Int) : ISet<K, V> {
		require("n must be positive.").toBe(n >= 0);
		
		if(n > size) {
        	return this;
      	} else if(0 == n) {
        	return this;
      	}
		
		var keys : Array<Int> = _keys.keys().toArray();
		var index : Int = size - n;
		while(--index > -1) {
			_keys.remove(keys[index]);
			_values.remove(keys[index]);
			_length--;
		}
			
      	return this;
	}
	
	public function takeWhile(f : (ITuple2<K, V> -> Bool)) : ISet<K, V> {
		var buffer : Array<ITuple2<K, V>> = new Array<ITuple2<K, V>>();
		var keys : Array<Int> = _keys.keys().toArray();
		var c : Int = 0;
		for(i in keys) {
			var k : K = _keys.get(i);
			var v : V = _values.get(i);
			var t : ITuple2<K, V> = tuple2(k, v).instance();
			if(f(t)) {
				buffer[c++] = t;
			} else {
				break;
			}
		}
		
		_keys = new IntHash<K>();
		_values = new IntHash<V>();
		_length = 0;
		
		for(tuple in buffer) {
			_keys.set(_length, tuple._1);
			_values.set(_length, tuple._2);
			_length++;
		}
		
		return this;
	}
	
	public function zip(that : ISet<Dynamic, Dynamic>) : ISet<ITuple2<K, V>, ITuple2<Dynamic, Dynamic>> {
		var n : Int = Std.int(Math.min(size, that.size));
		var buffer = new HashMap<ITuple2<K, V>, ITuple2<Dynamic, Dynamic>>();
		
		for(i in 0...n) {
			buffer.add(get(i).get(), that.get(i).get());
		}
		
      	return buffer;
	}
	
	public function addIterator(iterator : Iterator<ITuple2<K, V>>) : ISet<K, V> {
		return addAll(iterator.toSet());
	}
	
	public function addIterable(iterable : Iterable<ITuple2<K, V>>) : ISet<K, V> {
		return addAll(iterable.iterator().toSet());
	}
	
	override public function productElement(i : Int) : Dynamic {
		var keys:Iterator<Int> = _keys.keys();
		for(key in keys) {
			if(i == 0) {
				return tuple2(_keys.get(key), _values.get(key)).instance();
			}
			i -= 1;
		}

      	throw new NoSuchElementError();
	}
	
	private function get_nonEmpty() : Bool {
		return true;
	}
	
	public function get_isEmpty() : Bool {
		return false;
	}
	
	private function get_head() : ITuple2<K, V> {
		var keys:Iterator<Int> = _keys.keys();
		var key : Int = if(keys.hasNext()) {
			keys.next(); 
		}
		return tuple2(_keys.get(key), _values.get(key)).instance();
	}
	
	private function get_headOption() : Option<ITuple2<K, V>> {
		return if(size == 0) {
			None;
		} else {
			var keys:Iterator<Int> = _keys.keys();
			var key : Int = if(keys.hasNext()) {
				keys.next(); 
			}
			Some(tuple2(_keys.get(key), _values.get(key)).instance());
		}
	}
	
	private function get_init() : ISet<K, V> {
		return dropRight(1);
	}
	
	private function get_last() : Option<ITuple2<K, V>> {
      	return if(size == 0) {
			None;
		} else {
			var value: Option<ITuple2<K, V>> = None;
			var keys:Iterator<Int> = _keys.keys();
			var key:Int = 0;
			while(keys.hasNext()) {
				key = keys.next();		      	
			}
			Some(tuple2(_keys.get(key), _values.get(key)).instance());
		}
	}
		
	private function get_tail() : ISet<K, V> {
		var keys:Iterator<Int> = _keys.keys();
		// remove the first one.
		if(keys.hasNext()) {
			keys.next(); 
		}
		var s : HashMap<K, V> = new HashMap<K,V>();
		for(i in keys) {
			s.add(_keys.get(i), _values.get(i));
		}
		return s;
	}
	
	private function get_tailOption() : Option<ISet<K, V>> {
		return if(size == 0) {
			None;
		} else {
			var keys:Iterator<Int> = _keys.keys();
			// remove the first one.
			if(keys.hasNext()) {
				keys.next(); 
			}
			var s : HashMap<K, V> = new HashMap<K,V>();
			for(i in keys) {
				s.add(_keys.get(i), _values.get(i));
			}
			Some(cast s);
		}
	}
	
	private function get_zipWithIndex() : ISet<ITuple2<K, V>, Int> {
		var buffer = new HashMap<ITuple2<K, V>, Int>();
		var c:Int = 0;
		var keys:Iterator<Int> = _keys.keys();
		for(i in keys) {
			buffer.add(tuple2(_keys.get(i), _values.get(i)).instance(), c);
			c++;
		}
		return buffer;
	}
	
	private function get_size() : Int {
		return _length;
	}
	
	private function get_hasDefinedSize() : Bool {
		return true;
	}

	private function get_toArray() : Array<V> {
      	var array: Array<V> = new Array<V>();
      	for(i in _values) {
        	array.push(i);
      	}
	    return array;
	}
	
	private function get_flatten() : ISet<K, V> {
		return flatMap(function(x: Dynamic): ISet<K, V> { 
			return Std.is(x, ISet) ? cast x : x.toSet(); 
		});
	}
	
	private function get_iterator() : Iterator<Dynamic> {
		return null;//new HashMapIterator<Dynamic, Dynamic>(this);
	}
	
	override private function get_productArity() : Int {
		return size;
	}

	override private function get_productPrefix() : String {
		return "HashMap";
	}
}
