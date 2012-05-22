package funk.collections.mutable;

import funk.collections.IList;
import funk.collections.IteratorUtil;
import funk.collections.ListUtil;
import funk.collections.mutable.ListIterator;
import funk.collections.mutable.Nil;
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
using funk.collections.mutable.Nil;
using funk.option.Option;
using funk.tuple.Tuple2;
using funk.unit.Expect;
using funk.util.Require;

class List<T> extends Product, implements IList<T> {
	
	public var nonEmpty(get_nonEmpty, never) : Bool;

	public var head(get_head, never) : T;
	
	public var headOption(get_headOption, never) : Option<T>;

	public var indices(get_indices, never) : IList<Int>;

	public var init(get_init, never) : IList<T>;

	public var isEmpty(get_isEmpty, never) : Bool;

	public var last(get_last, never) : Option<T>;

	public var reverse(get_reverse, never) : IList<T>;

	public var tail(get_tail, never) : IList<T>;
	
	public var tailOption(get_tailOption, never) : Option<IList<T>>;

	public var zipWithIndex(get_zipWithIndex, never) : IList<ITuple2<T, Int>>;
	
	public var size(get_size, never) : Int;
	
	public var hasDefinedSize(get_hasDefinedSize, never) : Bool;
	
	public var toArray(get_toArray, never) : Array<T>;
	
	public var flatten(get_flatten, never) : IList<T>;
	
	private var _data : Array<T>;
	
	public function new() {
		super();
		
		_data = new Array<T>();
	}
		
	public function contains(value : T) : Bool {
		var total : Int = _data.length;
		for(i in 0...total) {
			if(expect(_data[i]).toEqual(value)) {
				return true;
			}
		}
		
		return false;
	}
	
	public function count(f : (T -> Bool)) : Int {
		var n : Int = 0;
		var total : Int = _data.length;
		for(i in 0...total) {
			if(f(_data[i])) {
				n++;
			}
		}
		
		return n;
	}
	
	public function drop(n : Int) : IList<T> {
		require("n must be positive.").toBe(n >= 0);
		
		_data.splice(0, Std.int(Math.min(n, size)));
		
		return _data.length == 0 ? nil.list() : this;
	}
	
	public function dropRight(n : Int) : IList<T> {
		require("n must be positive.").toBe(n >= 0);
		
		_data.splice(_data.length - n, _data.length);
		
		return this;
	}
	
	public function dropWhile(f : (T -> Bool)) : IList<T> {
		var total = _data.length;
		var index = total;
		for(i in 0...total) {
			if(!f(_data[i])) {
				break;
			}
			index--;
		}
		
		_data.splice(0, _data.length - index);

		return this;
	}
	
	public function exists(f : (T -> Bool)) : Bool {
		var total : Int = _data.length;
		for(i in 0...total) {
			if(f(_data[i])) {
				return true;
			}
		}

      	return false;
	}
	
	public function filter(f : (T -> Bool)) : IList<T> {
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
	
	public function filterNot(f : (T -> Bool)) : IList<T> {
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
	
	public function find(f : (T -> Bool)) : Option<T> {
		var total : Int = _data.length;
		for(i in 0...total) {
			if(f(_data[i])) {
				return Some(_data[i]);
			}
		}
		
      	return None;
	}
	
	public function flatMap(f : (T -> IList<T>)) : IList<T> {
		var total : Int = _data.length;
		var buffer: Array<IList<T>> = new Array<IList<T>>();
		for(i in 0...total) {
			buffer.push(f(_data[i]));
		}
		
		_data.splice(0, _data.length);
		
		var n = buffer.length;
      	while(--n > -1) {
			prependAll(buffer[n]);
      	}
		
		return this;
	}
	
	public function foldLeft(x : T, f : (T -> T -> T)) : T {
		var value : T = x;
		var total : Int = _data.length;
		for(i in 0...total) {
			value = f(value, _data[i]);
		}
		return value;
	}
	
	public function foldRight(x : T, f : (T -> T -> T)) : T {
		return x;
	}
	
	public function forall(f : (T -> Bool)) : Bool {
		var total : Int = _data.length;
		for(i in 0...total) {
			if(!f(_data[i])) {
				return false;
			}
		}
		
		return true;
	}
	
	public function foreach(f : (T -> Void)) : Void {
		var total : Int = _data.length;
		for(i in 0...total) {
			f(_data[i]);
		}
	}
	
	public function get(index : Int) : Option<T> {
		return Some(productElement(index));
	}
	
	public function map(f : (T -> T)) : IList<T> {
		var total : Int = _data.length;
		for(i in 0...total) {
			_data[i] = f(_data[i]);
		}
		return this;
	}
	
	public function partition(f : (T -> Bool)) : ITuple2<IList<T>, IList<T>> {
		var left: List<T> = new List<T>();
      	var right: List<T> = new List<T>();
		
		var total : Int = _data.length;
		for(i in 0...total) {
			var item = _data[i];
			if(f(item)) {
				left._data[left._data.length] = item;
			} else {
				right._data[right._data.length] = item;
			}
		}
		
		var m = left.size;
		var o = right.size;
		return tuple2(m > 0 ? left : nil.list(), o > 0 ? right : nil.list()).instance();
	}
	
	override public function equals(that: IFunkObject): Bool {
      	return if (Std.is(that, IList)) {
       		super.equals(that);
      	} else {
			false;
		}
    }
	
	public function prepend(value : T) : IList<T> {
		_data.unshift(value);
		return this;
	}
	
	public function prependAll(value : IList<T>) : IList<T> {
		var n: Int = value.size;

      	if(0 == n) {
        	return this;
      	}
		
		var iter = value.iterator();
      	for(i in iter) {
			_data.unshift(i);
		}

      	return this;
	}
	
	public function reduceLeft(f : (T -> T -> T)) : Option<T> {
		var value : T = head;
		var total : Int = _data.length;
		for(i in 0...total) {
			value = f(value, _data[i]);
		}
		return Some(value);
	}
	
	public function reduceRight(f : (T -> T -> T)) : Option<T> {
		var value : T = _data[_data.length - 1];
		var index : Int = _data.length - 1;
		while(--index > -1) {
			value = f(value, _data[index]);
		}
		return Some(value);
	}
	
	public function take(n : Int) : IList<T> {
		require("n must be positive.").toBe(n >= 0);
		
		var m = Std.int(Math.min(n, size));
		_data = _data.splice(0, m);
		
      	return this;
	}
	
	public function takeRight(n : Int) : IList<T> {
		require("n must be positive.").toBe(n >= 0);
		
		var m = Std.int(Math.min(n, size));
		_data = _data.splice(_data.length - m, m);

      	return this;
	}
	
	public function takeWhile(f : (T -> Bool)) : IList<T> {
		var buffer:Array<T> = new Array<T>();
		var n = size;
		for(i in 0...n) {
			var item : T = _data[i];
			if(f(item)) {
				buffer.push(item);		
			} else {
				break;
			}
		}
		
		_data = buffer;
		
		return this;
	}
	
	public function zip(that : IList<T>) : IList<ITuple2<T, T>> {
		var l: IList<ITuple2<T, T>> = nil.list();
		var n: Int = Std.int(Math.min(size, that.size));
		for(i in 0...n) {
			l.append(tuple2(_data[i], that.get(i).get()).instance());
		}
		
		return l;
	}
	
	public function findIndexOf(f: (T -> Bool)): Int {
		var index: Int = 0;
		
		var total : Int = _data.length;
		for(i in 0...total) {
			if(f(_data[i])) {
				return index;
			}
			index += 1;
		}

      	return -1;
	}
	
	public function indexOf(value : T) : Int {
		var index: Int = 0;
		
		var total : Int = _data.length;
		for(i in 0...total) {
			if(expect(_data[i]).toEqual(value)) {
				return index;
			}
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
		_data.push(value);
		return this;
	}

	public function appendAll(value : IList<T>) : IList<T> {
		var total : Int = value.size;
		var iter = value.iterator();
		for(i in iter) {
			_data.push(i);
		}
		return this;
	}

	public function appendIterator(iterator : Iterator<T>) : IList<T> {
		return appendAll(iterator.toList());
	}

	public function appendIterable(iterable : Iterable<T>) : IList<T> {
		return appendAll(iterable.iterator().toList());
	}
	
	override public function productElement(i : Int) : Dynamic {
		if(i >= 0 && i < size) {
			return _data[i];
		}

      	throw new NoSuchElementError();
	}
	
	private function get_nonEmpty() : Bool {
		return size > 0;
	}
	
	public function get_isEmpty() : Bool {
		return size == 0;
	}
	
	private function get_head() : T {
		return _data[0];
	}
	
	private function get_headOption() : Option<T> {
		return Some(_data[0]);
	}
	
	private function get_indices() : IList<Int> {
		var n: Int = size;
      	var p: IList<Int> = nil.list();

      	while(--n > -1) {
        	p = p.prepend(n);
      	}

      	return p;
	}
	
	private function get_init() : IList<T> {
		return dropRight(1);
	}
	
	private function get_last() : Option<T> {
		var l: Int = _data.length;
      	return if(l == 0) {
			None;
		} else {
			Some(_data[_data.length - 1]);
		}
	}
	
	private function get_reverse() : IList<T> {
		_data.reverse();
	    return this;
	}
	
	private function get_tail() : IList<T> {
		var l : List<T> = new List<T>();
        if(_data.length > 1) {
			l._data = _data.slice(1);
		}
		return l;
	}
	
	private function get_tailOption() : Option<IList<T>> {
		var l : List<T> = new List<T>();
        return if(_data.length > 1) {
			l._data = _data.slice(1);
			cast Some(l);
		} else {
			None;
		}
	}
	
	private function get_zipWithIndex() : IList<ITuple2<T, Int>> {
		var l: IList<ITuple2<T, Int>> = nil.list();
		var n: Int = size;
		for(i in 0...n) {
			l.append(tuple2(_data[i], i).instance());
		}
		
		return l;
	}
	
	private function get_size() : Int {
		return _data.length;
	}
	
	private function get_hasDefinedSize() : Bool {
		return true;
	}

	private function get_toArray() : Array<T> {
		var n: Int = size;
      	var array: Array<T> = new Array<T>();
      	var p: IList<T> = this;

     	for(i in 0...n) {
        	array[i] = p.head;
        	p = p.tail;
      	}

	    return array;
	}
	
	private function get_flatten() : IList<T> {
		return flatMap(function(x: Dynamic): IList<T> { 
			return Std.is(x, IList) ? cast x : x.toList(); 
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