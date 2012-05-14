package funk.collections.immutable;

import funk.product.Product2;

class HashMap<K, V> extends Product2<K, V>, implements ISet<K, V> {
	
	public var nonEmpty(dynamic, never): Bool;
	
    public var flatten(dynamic, never): ISet<K, V>;
	
    public var head(dynamic, never): ITuple2<K, V>;

	public var headOption(dynamic, never): Option<ITuple2<K, V>>;

    public var init(dynamic, never): ISet<K, V>;

    public var isEmpty(dynamic, never): Bool;

    public var last(dynamic, never): Option<ITuple<K, V>>;
	
    public var tail(dynamic, never): ISet<K, V>;
	
	public var tailOption(dynamic, never): Option<ISet<K, V>>;
	
	public var zipWithIndex(dynamic, never): ISet<ITuple2<K, V>, Int>;
	
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
			// FIXME (Simon) This should use a check
        	//if(eq(p.head._1, value)) {
        	if(p.head._1 == value) {
          		return true;
        	}
        	p = p.tail;
      	}

      	return false;
	}
	
	public function count(f : (ITuple2<K, V> -> Bool)) : Int {
		var n: Int = 0;
      	var p: ISet<K, V> = this;

      	while(p.nonEmpty) {
        	if(f(p.head)) {
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
          		return nil.instance();
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
        	return nil.instance();
      	}

      	var buffer = new Array<HashMap<K, V>>();
      	var m: Int = n - 1;
      	var p: ISet<K, V> = this;

      	for(i in 0...n) {
        	buffer[i] = new HashMap<K, V>(p.head, null);
        	p = p.tail;
      	}

      	buffer[m]._tail = nil.instance();
		
		var j : Int = 1;
		for(i in 0...m) {
        	buffer[i]._tail = buffer[j];
			j++;
      	}

      	return buffer[0];
	}
	
	public function dropWhile(f : (ITuple2<K, V> -> Bool)) : ISet<K, V> {
		var p: ISet<K, V> = this;

      	while(p.nonEmpty) {
        	if(!f(p.head)) {
          		return p;
        	}

        	p = p.tail;
      }

      return nil.instance();
	}
	
	public function exists(f : (ITuple2<K, V> -> Bool)) : Bool {
		var p: ISet<K, V> = this;

      	while(p.nonEmpty) {
        	if(f(p.head)) {
          		return true;
        	}

        	p = p.tail;
      	}

      	return false;
	}
	
	public function filter(f : (ITuple2<K, V> -> Bool)) : ISet<K, V> {
		var p: ISet<K, V> = this;
      	var q: HashMap<K, V> = null;
      	var first: HashMap<K, V> = null;
      	var last: HashMap<K, V> = null;
      	var allFiltered: Bool = true;

      	while(p.nonEmpty) {
        	if(f(p.head)) {
          		q = new HashMap<K, V>(p.head, nil.instance());

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

      	return (first == null) ? nil.instance() : first;
	}
	
	public function filterNot(f : (ITuple2<K, V> -> Bool)) : ISet<K, V> {
		var p: ISet<K, V> = this;
      	var q: HashMap<K, V> = null;
      	var first: HashMap<K, V> = null;
      	var last: HashMap<K, V> = null;
      	var allFiltered: Bool = true;

      	while(p.nonEmpty) {
        	if(!f(p.head)) {
          		q = new HashMap<K, V>(p.head, nil.instance());

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

      	return (first == null) ? nil.instance() : first;
	}
	
	public function find(f : (ITuple2<K, V> -> Bool)) : Option<ITuple2<K, V>> {
		var p: ISet<K, V> = this;

      	while(p.nonEmpty) {
        	if(f(p.head)) {
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
	
	public function forall(f : (ITuple2<K, V> -> Bool)) : Bool {
		var p: ISet<K, V> = this;

      	while(p.nonEmpty) {
        	if(!f(p.head)) {
          		return false;
        	}

        	p = p.tail;
      	}

      	return true;
	}
	
	public function foreach(f : (T -> Void)) : Void {
		var p: ISet<K, V> = this;

      	while(p.nonEmpty) {
        	f(p.head);
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

      	buffer[m]._tail = nil.instance();
		
		var j : Int = 1;
		for(i in 0...m) {
        	buffer[i]._tail = buffer[j];
			j++;
      	}

      	return buffer[0];
	}
	
	public function partition(f : (ITuple2<K, V> -> Bool)) : ITuple2<ISet<K, V>, ISet<K, V>> {
		var left: Array<HashMap<K, V>> = new Array<HashMap<K, V>>();
      	var right: Array<HashMap<K, V>> = new Array<HashMap<K, V>>();

      	var i: Int = 0;
      	var j: Int = 0;
      	var m: Int = 0;
      	var o: Int = 0;

      	var p: ISet<K, V> = this;

      	while(p.nonEmpty) {
        	if(f(p.head)) {
          		left[i++] = new HashMap(p.head, nil.instance());
        	} else {
          		right[j++] = new HashMap(p.head, nil.instance());
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

      	return tuple2(m > 0 ? left[0] : nil.instance(), o > 0 ? right[0] : nil.instance()).instance();
	}
	
	public function add(value : ITuple2<K, V>) : ISet<K, V> {
		return new HashMap<K, V>(value, this);
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
        	return nil.instance();
      	}

      	var buffer: Array<HashMap<K, V>> = new Array<HashMap<K, V>>();
      	var m: Int = n - 1;
      	var p: ISet<K, V> = this;

      	for(i in 0...n) {
        	buffer[i] = new HashMap<K, V>(p.head, null);
        	p = p.tail;
      	}

      	buffer[m]._tail = nil.instance();

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
        	return nil.instance();
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
        	return nil.instance();
      	}
      
      	buffer[m]._tail = nil.instance();

		var j : Int = 1;
		for(i in 0...m) {
        	buffer[i]._tail = buffer[j];
			j++;
      	}

      	return buffer[0];
	}
	
	public function zip(that : ISet<Dynamic, Dynamic>) : ISet<ITuple2<ITuple2<K, V>, ITuple2<ITuple<Dynamic, Dynamic>>> {
		var n: Int = Std.int(Math.min(size, that.size));
      	var m: Int = n - 1;
      	var buffer = new Array<HashMap<ITuple2<ITuple2<K, V>, ITuple2<ITuple<Dynamic, Dynamic>>>>();

      	var p: ISet<K, V> = this;
		var q: ISet<K, V> = that;

		for(i in 0...n) {
        	buffer[i] = new HashMap(tuple2(p.head, q.head).instance(), null);
        	p = p.tail;
        	q = q.tail;
      	}

      	buffer[m]._tail = nil.instance();

		var j : Int = 1;
		for(i in 0...m) {
        	buffer[i]._tail = buffer[j];
			j++;
      	}

      	return buffer[0];
	}
	
	public function addIterator(iterator : Iterator<T>) : ISet<K, V> {
		return addAll(iterator.toSet());
	}
	
	public function addIterable(iterable : Iterable<T>) : ISet<K, V> {
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
	
	private function get_zipWithIndex() : ISet<ITuple2<K, V>, Int>; {
		var n: Int = Std.int(Math.min(size, that.size));
      	var m: Int = n - 1;
      	var buffer = new Array<HashMap<ITuple2<ITuple2<K, V>, Int>>();

      	var p: ISet<K, V> = this;

		for(i in 0...n) {
        	buffer[i] = new HashMap(tuple2(p.head, i).instance(), null);
        	p = p.tail;
      	}

      	buffer[m]._tail = nil.instance();

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
		return flatMap(function(x: T): ISet<K, V> { 
			return Std.is(x, ISet) ? cast x : x.toSet(); 
		});
	}
	
	private function get_iterator() : Iterator<Dynamic> {
		return new HashMapIterator<Dynamic>(this);
	}
	
	override private function get_productArity() : Int {
		return size;
	}

	override private function get_productPrefix() : String {
		return "HashMap";
	}
}
