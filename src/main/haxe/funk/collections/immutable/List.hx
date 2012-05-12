package funk.collections.immutable;

import funk.errors.NoSuchElementError;
import funk.errors.RangeError;
import funk.product.Product1;
import funk.collections.IList;
import funk.option.Option;
import funk.tuple.Tuple2;
import funk.util.Require;
import funk.collections.IteratorUtil;
import funk.collections.ListUtil;

using funk.tuple.Tuple2;
using funk.util.Require;
using funk.option.Option;
using funk.collections.IteratorUtil;
using funk.collections.ListUtil;


class List<T> extends Product1<T>, implements IList<T> {
	
	public var nonEmpty(get_nonEmpty, never) : Bool;

	public var head(get_head, never) : Option<T>;

	public var indices(get_indices, never) : IList<T>;

	public var init(get_init, never) : IList<T>;

	public var isEmpty(get_isEmpty, never) : Bool;

	public var last(get_last, never) : Option<T>;

	public var reverse(get_reverse, never) : IList<T>;

	public var tail(get_tail, never) : Option<IList<T>>;

	public var zipWithIndex(get_zipWithIndex, never) : IList<T>;
	
	public var size(get_size, never) : Int;
	
	public var hasDefinedSize(get_hasDefinedSize, never) : Bool;
	
	public var toArray(get_toArray, never) : Array<T>;
	
	public var flatten(get_flatten, never) : IList<T>;
	
	private var _head : T;
	
	private var _tail : IList<T>;
	
	private var _length : Int;
	
	private var _lengthKnown : Bool;
	
	public function new(head : T, tail : IList<T>) {
		super();
		
		_head = head;
		_tail = tail;
		
		_length = 0;
		_lengthKnown = false;
	}
	
	public function contains(value : T) : Bool {
		var p: IList<T> = this;

      	while(p.nonEmpty) {
        	if(eq(p.head, value)) {
          		return true;
        	}
        	p = p.tail.get();
      	}

      	return false;
	}
	
	public function count(f : (T -> Bool)) : Int {
		var n: Int = 0;
      	var p: IList = this;

      	while(p.nonEmpty) {
        	if(f(p.head)) {
          		++n;
        	}

        	p = p.tail.get();
      	}

      	return n;
	}
	
	public function drop(n : Int) : IList<T> {
		require("n must be positive.").toBe(n >= 0);

      	var p: IList<T> = this;

      	for(i in 0...n) {
        	if(p.isEmpty) {
          		return nil.instance();
        	}

        	p = p.tail.get();
      	}

      	return p;
	}
	
	public function dropRight(n : Int) : IList<T> {
		require("n must be positive.").toBe(n >= 0);
		
		return NilType.instance(nil);
	}
	
	public function dropWhile(f : (T -> Bool)) : IList<T> {
		var p: IList<T> = this;

      	while(p.nonEmpty) {
        	if(!f(p.head)) {
          		return p;
        	}

        	p = p.tail.get();
      }

      return nil.instance();
	}
	
	public function exists(f : (T -> Bool)) : Bool {
		var p: IList<T> = this;

      	while(p.nonEmpty) {
        	if(f(p.head)) {
          		return true;
        	}

        	p = p.tail.get();
      	}

      	return false;
	}
	
	public function filter(f : (T -> Bool)) : IList<T> {
		return NilType.instance(nil);
	}
	
	public function filterNot(f : (T -> Bool)) : IList<T> {
		return NilType.instance(nil);
	}
	
	public function find(f : (T -> Bool)) : Option<T> {
		var p: IList<T> = this;

      	while(p.nonEmpty) {
        	if(f(p.head)) {
          		return Some(p.head);
        	}

        	p = p.tail.get();
      	}

      	return None;
	}
	
	public function flatMap(f : (T -> IList<T>)) : IList<T> {
		return NilType.instance(nil);
	}
	
	public function foldLeft(x : T, f : (T -> T)) : T {
		return x;
	}
	
	public function foldRight(x : T, f : (T -> T)) : T {
		return x;
	}
	
	public function forall(f : (T -> Bool)) : Bool {
		return false;
	}
	
	public function foreach(f : (T -> Void)) : Void {
	}
	
	public function get(index : Int) : Option<T> {
		return productElement(index);
	}
	
	public function map(f : (T -> T)) : IList<T> {
		return NilType.instance(nil);
	}
	
	public function partition(f : (T -> Bool)) : ITuple2<IList<T>, IList<T>> {
		return tuple2(NilType.instance(nil), NilType.instance(nil)).instance();
	}
	
	public function prepend(value : T) : IList<T> {
		return new List(value, this);
	}
	
	public function prependAll(value : IList<T>) : IList<T> {
		return value;
	}
	
	public function reduceLeft(f : (T -> T)) : Option<T> {
		var value: T = head;
      	var p: IList<T> = _tail;

      	while(p.nonEmpty) {
        	value = f(value, p.head);
        	p = p.tail.get();
      	}

      	return value;
	}
	
	public function reduceRight(f : (T -> T)) : Option<T> {
		var buffer: Array = toArray;
      	var value: T = buffer.pop();
      	var n: Int = buffer.length;

      	while(--n > -1) {
        	value = f(value, buffer[n]);
      	}

      	return value;
	}
	
	public function take(n : Int) : IList<T> {
		require("n must be positive.").toBe(n >= 0);
		
		return NilType.instance(nil);
	}
	
	public function takeRight(n : Int) : IList<T> {
		require("n must be positive.").toBe(n >= 0);
		
		return NilType.instance(nil);
	}
	
	public function takeWhile(f : (T -> Bool)) : IList<T> {
		return NilType.instance(nil);
	}
	
	public function zip(that : IList<T>) : IList<T> {
		return NilType.instance(nil);
	}
	
	public function findIndexOf(f: (T -> Bool)): Int {
		var index: Int = 0;
      	var p: IList<T> = this;

      	while(p.nonEmpty) {
        	if(f(p.head)) {
          		return index;
        	}

        	p = p.tail.get();
        	index += 1;
      	}

      	return -1;
	}
	
	public function indexOf(value : T) : Int {
		var index: Int = 0;
      	var p: IList<T> = this;

      	while(p.nonEmpty) {
        	if(eq(p.head, value)) {
          		return index;
        	}

        	p = p.tail.get();
        	index += 1;
      	}

      	return -1;
	}
	
	public function prependIterator(iterator : Iterator<T>) : IList<T> {
		return prependAll(iterator.toList());
	}
	
	public function prependIterable(iterable : Iterable<T>) : IList<T> {
		return prependAll(iterable.iterator().toList());
	}
	
	public function append(value : T) : IList<T> {
		return new List(value, this);
	}

	public function appendAll(value : IList<T>) : IList<T> {
		return value;
	}

	public function appendIterator(iterator : Iterator<T>) : IList<T> {
		return appendAll(iterator.toList());
	}

	public function appendIterable(iterable : Iterable<T>) : IList<T> {
		return appendAll(iterable.iterator().toList());
	}
	
	override public function productElement(i : Int) : Dynamic {
		var p: IList<T> = this;

      	while(p.nonEmpty) {
        	if(i == 0) {
        	  return p.head;
        	}

        	p = p.tail.get();
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
	
	private function get_head() : Option<T> {
		return Some(_head);
	}
	
	private function get_indices() : IList<Int> {
		var n: Int = size;
      	var p: IList<Int> = nil.instance();

      	while(--n > -1) {
        	p = p.prepend(n);
      	}

      	return p;
	}
	
	private function get_init() : IList<T> {
		return dropRight(1);
	}
	
	private function get_last() : Option<T> {
		var p: IList = this;
      	var value: Option<T> = None;
      	while(p.nonEmpty) {
        	value = p.head;
        	p = p.tail.get();
      	}
      	return value;
	}
	
	private function get_reverse() : IList<T> {
		return NilType.instance(nil);
	}
	
	private function get_tail() : Option<IList<T>> {
		return Some(_tail);
	}
	
	private function get_zipWithIndex() : IList<T> {
		return NilType.instance(nil);
	}
	
	private function get_size() : Int {
		if(_lengthKnown) {
        	return _length;
      	}

      	var p: IList<T> = this;
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

	private function get_toArray() : Array<T> {
		var n: Int = size;
      	var array: Array = [];
      	var p: IList<T> = this;

     	for(i in 0...n) {
        	array[i] = switch(p.head) {
				case None: null;
				case Some(value): value;
			};
        	p = p.tail.get();
      	}

	    return array;
	}
	
	private function get_flatten() : IList<T> {
		return flatMap(function(x: T): IList<T> { 
			return Std.is(x, IList) ? x : x.toList(); 
		});
	}
	
	private function get_iterator() : Iterator<Dynamic> {
		return new ListIterator<Dynamic>(this);
	}
	
	override private function get_productArity() : Int {
		return size;
	}

	override private function get_productPrefix() : String {
		return "List";
	}
}
