package funk.collections.immutable;

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
using funk.collections.ListUtil;
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
	
	private var _head : ITuple2<K, V>;
	
	private var _tail : ISet<K, V>;
	
	private var _length : Int;
	
	private var _lengthKnown : Bool;
	
	public function new(head : ITuple2<K, V>, tail : ISet<K, V>) {
		super();
		
		_head = head;
		_tail = tail;
		
		_length = 0;
		_lengthKnown = false;
	}
	
	public function contains(value : K) : Bool {
		var p: ISet<K, V> = this;

      	while(p.nonEmpty) {
			if(expect(p.head._1).toEqual(value)) {
          		return true;
        	}
        	p = p.tail;
      	}

      	return false;
	}
	
	public function count(f : (K -> V -> Bool)) : Int {
		var n: Int = 0;
      	var p: ISet<K, V> = this;

      	while(p.nonEmpty) {
        	if(f(p.head._1, p.head._2)) {
          		++n;
        	}

        	p = p.tail;
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

      	var buffer = new Array<HashMap<K, V>>();
      	var m: Int = n - 1;
      	var p: ISet<K, V> = this;

      	for(i in 0...n) {
        	buffer[i] = new HashMap<K, V>(p.head, null);
        	p = p.tail;
      	}

      	buffer[m]._tail = nil.set();
		
		var j : Int = 1;
		for(i in 0...m) {
        	buffer[i]._tail = buffer[j];
			j++;
      	}

      	return buffer[0];
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
		var p: ISet<K, V> = this;
      	var q: HashMap<K, V> = null;
      	var first: HashMap<K, V> = null;
      	var last: HashMap<K, V> = null;
      	var allFiltered: Bool = true;

      	while(p.nonEmpty) {
        	if(f(p.head._1, p.head._2)) {
          		q = new HashMap<K, V>(p.head, nil.set());

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

      	return (first == null) ? nil.set() : first;
	}
	
	public function filterNot(f : (K -> V -> Bool)) : ISet<K, V> {
		var p: ISet<K, V> = this;
      	var q: HashMap<K, V> = null;
      	var first: HashMap<K, V> = null;
      	var last: HashMap<K, V> = null;
      	var allFiltered: Bool = true;

      	while(p.nonEmpty) {
        	if(!f(p.head._1, p.head._2)) {
          		q = new HashMap<K, V>(p.head, nil.set());

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

      	return (first == null) ? nil.set() : first;
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
	
	public function get(index : Int) : Option<V> {
		return productElement(index);
	}
	
	public function map(f : (ITuple2<K, V> -> ITuple2<K, V>)) : ISet<K, V> {
		var n: Int = size;
      	var buffer: Array<HashMap<K, V>> = new Array<HashMap<K, V>>();
      	var m: Int = n - 1;

      	var p: ISet<K, V> = this;

      	for(i in 0...n) {
        	buffer[i] = new HashMap<K, V>(f(p.head), null);
        	p = p.tail;
      	}

      	buffer[m]._tail = nil.set();
		
		var j : Int = 1;
		for(i in 0...m) {
        	buffer[i]._tail = buffer[j];
			j++;
      	}

      	return buffer[0];
	}
	
	public function partition(f : (K -> V -> Bool)) : ITuple2<ISet<K, V>, ISet<K, V>> {
		var left: Array<HashMap<K, V>> = new Array<HashMap<K, V>>();
      	var right: Array<HashMap<K, V>> = new Array<HashMap<K, V>>();

      	var i: Int = 0;
      	var j: Int = 0;
      	var m: Int = 0;
      	var o: Int = 0;

      	var p: ISet<K, V> = this;

      	while(p.nonEmpty) {
        	if(f(p.head._1, p.head._2)) {
          		left[i++] = new HashMap<K, V>(p.head, nil.set());
        	} else {
          		right[j++] = new HashMap<K, V>(p.head, nil.set());
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

      	return tuple2(m > 0 ? left[0] : nil.set(), o > 0 ? right[0] : nil.set()).instance();
	}
	
	override public function equals(that: IFunkObject): Bool {
      	return if (Std.is(that, ISet)) {
       		super.equals(that);
      	} else {
			false;
		}
    }
	
	public function add(key : K, value : V) : ISet<K, V> {
		return new HashMap<K, V>(tuple2(key, value).instance(), this);
	}
	
	public function addAll(value : ISet<K, V>) : ISet<K, V> {
		var n: Int = value.size;

      	if(0 == n) {
        	return this;
      	}

      	var buffer: Array<HashMap<K, V>> = new Array<HashMap<K, V>>();
      	var m: Int = n - 1;
      	var p: ISet<K, V> = value;
      	var i: Int = 0;

      	while(p.nonEmpty) {
        	buffer[i++] = new HashMap<K, V>(p.head, null);
        	p = p.tail;
      	}

      	buffer[m]._tail = this;

		var j : Int = 1;
		for(i in 0...m) {
        	buffer[i]._tail = buffer[j];
			j++;
      	}

      	return buffer[0];
	}
	
	public function reduceLeft(f : (ITuple2<K, V> -> ITuple2<K, V> -> ITuple2<K, V>)) : Option<ITuple2<K, V>> {
		var value: ITuple2<K, V> = head;
      	var p: ISet<K, V> = _tail;

      	while(p.nonEmpty) {
        	value = f(value, p.head);
        	p = p.tail;
      	}

      	return Some(value);
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

      	var buffer: Array<HashMap<K, V>> = new Array<HashMap<K, V>>();
      	var m: Int = n - 1;
      	var p: ISet<K, V> = this;

      	for(i in 0...n) {
        	buffer[i] = new HashMap<K, V>(p.head, null);
        	p = p.tail;
      	}

      	buffer[m]._tail = nil.set();

		var j : Int = 1;
		for(i in 0...m) {
        	buffer[i]._tail = buffer[j];
			j++;
      	}

      	return buffer[0];
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
		var buffer: Array<HashMap<K, V>> = new Array<HashMap<K, V>>();
      	var p: ISet<K, V> = this;
      	var n: Int = 0;

      	while(p.nonEmpty) {
        	if(f(p)) {
          		buffer[n++] = new HashMap<K, V>(p.head, null);
          		p = p.tail;
        	} else {
          		break;
        	}
      	}

      	var m: Int = n - 1;

      	if(m <= 0) {
        	return nil.set();
      	}
      
      	buffer[m]._tail = nil.set();

		var j : Int = 1;
		for(i in 0...m) {
        	buffer[i]._tail = buffer[j];
			j++;
      	}

      	return buffer[0];
	}
	
	public function zip(that : ISet<Dynamic, Dynamic>) : ISet<ITuple2<K, V>, ITuple2<Dynamic, Dynamic>> {
		var n: Int = Std.int(Math.min(size, that.size));
      	var m: Int = n - 1;
      	var buffer = new Array<HashMap<ITuple2<K, V>, ITuple2<Dynamic, Dynamic>>>();

      	var p: ISet<K, V> = this;
		var q: ISet<Dynamic, Dynamic> = that;

		for(i in 0...n) {
        	buffer[i] = new HashMap<ITuple2<K, V>, ITuple2<Dynamic, Dynamic>>(tuple2(p.head, q.head).instance(), null);
        	p = p.tail;
        	q = q.tail;
      	}

      	buffer[m]._tail = nil.set();

		var j : Int = 1;
		for(i in 0...m) {
        	buffer[i]._tail = buffer[j];
			j++;
      	}

      	return buffer[0];
	}
	
	public function addIterator(iterator : Iterator<ITuple2<K, V>>) : ISet<K, V> {
		return addAll(iterator.toSet());
	}
	
	public function addIterable(iterable : Iterable<ITuple2<K, V>>) : ISet<K, V> {
		return addAll(iterable.iterator().toSet());
	}
	
	override public function productElement(i : Int) : Dynamic {
		var p: ISet<K, V> = this;

      	while(p.nonEmpty) {
        	if(i == 0) {
        	  return p.head;
        	}

        	p = p.tail;
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
		return _head;
	}
	
	private function get_headOption() : Option<ITuple2<K, V>> {
		return Some(_head);
	}
	
	private function get_init() : ISet<K, V> {
		return dropRight(1);
	}
	
	private function get_last() : Option<ITuple2<K, V>> {
		var p: ISet<K, V> = this;
      	var value: Option<ITuple2<K, V>> = None;
      	while(p.nonEmpty) {
        	value = p.headOption;
        	p = p.tail;
      	}
      	return value;
	}
		
	private function get_tail() : ISet<K, V> {
		return _tail;
	}
	
	private function get_tailOption() : Option<ISet<K, V>> {
		return Some(_tail);
	}
	
	private function get_zipWithIndex() : ISet<ITuple2<K, V>, Int> {
		var n: Int = size;
      	var m: Int = n - 1;
      	var buffer = new Array<HashMap<ITuple2<K, V>, Int>>();

      	var p: ISet<K, V> = this;

		for(i in 0...n) {
        	buffer[i] = new HashMap<ITuple2<K, V>, Int>(tuple2(p.head, i).instance(), null);
        	p = p.tail;
      	}

      	buffer[m]._tail = nil.set();

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

      	var p: ISet<K, V> = this;
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

	private function get_toArray() : Array<V> {
		var n: Int = size;
      	var array: Array<V> = new Array<V>();
      	var p: ISet<K, V> = this;

     	for(i in 0...n) {
        	array[i] = p.head._2;
        	p = p.tail;
      	}

	    return array;
	}
	
	private function get_flatten() : ISet<K, V> {
		return flatMap(function(x: Dynamic): ISet<K, V> { 
			return Std.is(x, ISet) ? cast x : x.toSet(); 
		});
	}
	
	private function get_iterator() : Iterator<Dynamic> {
		return new HashMapIterator<Dynamic, Dynamic>(this);
	}
	
	override private function get_productArity() : Int {
		return size;
	}

	override private function get_productPrefix() : String {
		return "HashMap";
	}
}
