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
		var keys = _keys.keys();
		for(i in keys) {
			if(f(_keys.get(i), _values.get(i))) {
				n++;
			}
		}
      	return n;
	}
	
	public function drop(n : Int) : ISet<K, V> {
		require("n must be positive.").toBe(n >= 0);

      	var p: ISet<K, V> = this;

      	for(i in 0...n) {
        	if(p.isEmpty) {
          		return nil.set();
        	}

        	p = p.tail;
      	}

      	return p;
	}
	
	public function dropRight(n : Int) : ISet<K, V> {
		require("n must be positive.").toBe(n >= 0);
		
		if(0 == n) {
			return this;
      	}
      
      	n = size - n;

      	if(n <= 0) {
        	return nil.set();
      	}

		return this;
	}
	
	public function dropWhile(f : (K -> V -> Bool)) : ISet<K, V> {
		var p: ISet<K, V> = this;

      	while(p.nonEmpty) {
        	if(!f(p.head._1, p.head._2)) {
          		return p;
        	}

        	p = p.tail;
      }

      return nil.set();
	}
	
	public function exists(f : (K -> V -> Bool)) : Bool {
		var p: ISet<K, V> = this;

      	while(p.nonEmpty) {
        	if(f(p.head._1, p.head._2)) {
          		return true;
        	}

        	p = p.tail;
      	}

      	return false;
	}
	
	public function filter(f : (K -> V -> Bool)) : ISet<K, V> {
		return this;
	}
	
	public function filterNot(f : (K -> V -> Bool)) : ISet<K, V> {
		return this;
	}
	
	public function find(f : (K -> V -> Bool)) : Option<ITuple2<K, V>> {
		var p: ISet<K, V> = this;

      	while(p.nonEmpty) {
        	if(f(p.head._1, p.head._2)) {
          		return p.headOption;
        	}

        	p = p.tail;
      	}

      	return None;
	}
	
	public function flatMap(f : (ITuple2<K, V> -> ISet<K, V>)) : ISet<K, V> {
		var n: Int = size;
      	var buffer: Array<ISet<K, V>> = new Array<ISet<K, V>>();
      	var p: ISet<K, V> = this;
      	var i: Int = 0;

      	while(p.nonEmpty) {
			// TODO (Simon) We should verify the type.
        	buffer[i++] = f(p.head); 
        	p = p.tail;
      	}

      	var s: ISet<K, V> = buffer[--n];

      	while(--n > -1) {
        	s = s.addAll(buffer[n]);
      	}

      	return s;
	}
	
	public function foldLeft(x : ITuple2<K, V>, f : (ITuple2<K, V> -> ITuple2<K, V> -> ITuple2<K, V>)) : ITuple2<K, V> {
		var value: ITuple2<K, V> = x;
      	var p: ISet<K, V> = this;

      	while(p.nonEmpty) {
        	value = f(value, p.head);
        	p = p.tail;
      	}

      	return value;
	}
	
	public function foldRight(x : ITuple2<K, V>, f : (ITuple2<K, V> -> ITuple2<K, V> -> ITuple2<K, V>)) : ITuple2<K, V> {
		var value: ITuple2<K, V> = x;
      	var buffer: Array<ITuple2<K, V>> = new Array<ITuple2<K, V>>();
		
		var p: ISet<K, V> = this;
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
	
	public function forall(f : (K -> V -> Bool)) : Bool {
		var p: ISet<K, V> = this;

      	while(p.nonEmpty) {
        	if(!f(p.head._1, p.head._2)) {
          		return false;
        	}

        	p = p.tail;
      	}

      	return true;
	}
	
	public function foreach(f : (K -> V -> Void)) : Void {
		var p: ISet<K, V> = this;

      	while(p.nonEmpty) {
        	f(p.head._1, p.head._2);
        	p = p.tail;
      	}
	}
	
	public function get(index : Int) : Option<ITuple2<K, V>> {
		return Some(productElement(index));
	}
	
	public function map(f : (ITuple2<K, V> -> ITuple2<K, V>)) : ISet<K, V> {
		return this;
	}
	
	public function partition(f : (K -> V -> Bool)) : ITuple2<ISet<K, V>, ISet<K, V>> {
      	return tuple2(nil.set(), nil.set()).instance();
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
      	return Some(null);
	}
	
	public function reduceRight(f : (ITuple2<K, V> -> ITuple2<K, V> -> ITuple2<K, V>)) : Option<ITuple2<K, V>> {
		var buffer: Array<ITuple2<K, V>> = new Array<ITuple2<K, V>>();
		
		var p: ISet<K, V> = this;
		while(p.nonEmpty) {
        	buffer.push(p.head); 
        	p = p.tail;
      	}
		
      	var value: ITuple2<K, V> = buffer.pop();
      	var n: Int = buffer.length;

      	while(--n > -1) {
        	value = f(value, buffer[n]);
      	}

      	return Some(value);
	}
	
	public function take(n : Int) : ISet<K, V> {
		require("n must be positive.").toBe(n >= 0);
		
		if(n > size) {
        	return this;
      	} else if(0 == n) {
        	return nil.set();
      	}

      	return this;
	}
	
	public function takeRight(n : Int) : ISet<K, V> {
		require("n must be positive.").toBe(n >= 0);
		
		if(n > size) {
        	return this;
      	} else if(0 == n) {
        	return nil.set();
      	}

      	n = size - n;

      	if(n <= 0) {
        	return this;
      	}

      	var p: ISet<K, V> = this;
		
		for(i in 0...n) {
        	p = p.tail;
      	}

      	return p;
	}
	
	public function takeWhile(f : (ISet<K, V> -> Bool)) : ISet<K, V> {
		return this;
	}
	
	public function zip(that : ISet<Dynamic, Dynamic>) : ISet<ITuple2<K, V>, ITuple2<Dynamic, Dynamic>> {
      	return null;
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
