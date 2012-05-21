package funk.collections.immutable;

import funk.collections.IteratorUtil;
import funk.collections.immutable.Nil;
import funk.errors.NoSuchElementError;
import funk.errors.RangeError;
import funk.product.Product;
import funk.option.Option;
import funk.tuple.Tuple2;
import funk.util.Require;

using funk.collections.IteratorUtil;
using funk.collections.immutable.Nil;
using funk.option.Option;
using funk.tuple.Tuple2;
using funk.util.Require;

class HashMapNil<K, V> extends Product, implements ISet<K, V> {
	
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
	
	public function new() {
		super();
	}
	
	public function contains(value : K) : Bool {
      	return false;
	}
	
	public function count(f : (K -> V -> Bool)) : Int {
      	return 0;
	}
	
	public function drop(n : Int) : ISet<K, V> {
		require("n must be positive.").toBe(n >= 0);
		
      	return nil.set();
	}
	
	public function dropRight(n : Int) : ISet<K, V> {
		require("n must be positive.").toBe(n >= 0);
		
		return nil.set();
	}
	
	public function dropWhile(f : (K -> V -> Bool)) : ISet<K, V> {
		return nil.set();
	}
	
	public function exists(f : (K -> V -> Bool)) : Bool {
      	return false;
	}
	
	public function filter(f : (K -> V -> Bool)) : ISet<K, V> {
		return nil.set();
	}
	
	public function filterNot(f : (K -> V -> Bool)) : ISet<K, V> {
		return nil.set();
	}
	
	public function find(f : (K -> V -> Bool)) : Option<ITuple2<K, V>> {
      	return None;
	}
	
	public function flatMap(f : (ITuple2<K, V> -> ISet<K, V>)) : ISet<K, V> {
      	return nil.set();
	}
	
	public function foldLeft(x : ITuple2<K, V>, f : (ITuple2<K, V> -> ITuple2<K, V> -> ITuple2<K, V>)) : ITuple2<K, V> {
      	return x;
	}
	
	public function foldRight(x : ITuple2<K, V>, f : (ITuple2<K, V> -> ITuple2<K, V> -> ITuple2<K, V>)) : ITuple2<K, V> {
      	return x;
	}
	
	public function forall(f : (K -> V -> Bool)) : Bool {
      	return false;
	}
	
	public function foreach(f : (K -> V -> Void)) : Void {
	}
	
	public function get(index : Int) : Option<V> {
		return None;
	}
	
	public function map(f : (ITuple2<K, V> -> ITuple2<K, V>)) : ISet<K, V> {
		return nil.set();
	}
	
	public function partition(f : (K -> V -> Bool)) : ITuple2<ISet<K, V>, ISet<K, V>> {
		return tuple2(nil.set(), nil.set()).instance();
	}
	
	public function add(key : K, value : V) : ISet<K, V> {
		return new HashMap<K, V>(tuple2(key, value).instance(), this);
	}
	
	public function addAll(value : ISet<K, V>) : ISet<K, V> {
		return value;
	}
	
	public function reduceLeft(f : (ITuple2<K, V> -> ITuple2<K, V> -> ITuple2<K, V>)) : Option<ITuple2<K, V>> {
		return None;
	}
	
	public function reduceRight(f : (ITuple2<K, V> -> ITuple2<K, V> -> ITuple2<K, V>)) : Option<ITuple2<K, V>> {
		return None;
	}
	
	public function take(n : Int) : ISet<K, V> {
		require("n must be positive.").toBe(n >= 0);
		
		return nil.set();
	}
	
	public function takeRight(n : Int) : ISet<K, V> {
		require("n must be positive.").toBe(n >= 0);
		
		return nil.set();
	}
	
	public function takeWhile(f : (ISet<K, V> -> Bool)) : ISet<K, V> {
		return nil.set();
	}
	
	public function zip(that : ISet<Dynamic, Dynamic>) : ISet<ITuple2<K, V>, ITuple2<Dynamic, Dynamic>> {
		return nil.set();
	}
	
	public function addIterator(iterator : Iterator<ITuple2<K, V>>) : ISet<K, V> {
		return addAll(iterator.toSet());
	}
	
	public function addIterable(iterable : Iterable<ITuple2<K, V>>) : ISet<K, V> {
		return addAll(iterable.iterator().toSet());
	}
	
	override public function productElement(i : Int) : Dynamic {
		throw new RangeError();
	}
	
	private function get_nonEmpty() : Bool {
		return false;
	}
	
	public function get_isEmpty() : Bool {
		return true;
	}
	
	private function get_head() : ITuple2<K, V> {
		return null;
	}
	
	private function get_headOption() : Option<ITuple2<K, V>> {
		return None;
	}
	
	private function get_init() : ISet<K, V> {
		return nil.set();
	}
	
	private function get_last() : Option<ITuple2<K, V>> {
		return None;
	}
		
	private function get_tail() : ISet<K, V> {
		return null;
	}
	
	private function get_tailOption() : Option<ISet<K, V>> {
		return None;
	}
	
	private function get_zipWithIndex() : ISet<ITuple2<K, V>, Int> {
		return nil.set();
	}
	
	private function get_size() : Int {
		return 0;
	}
	
	private function get_hasDefinedSize() : Bool {
		return true;
	}

	private function get_toArray() : Array<V> {
	    return [];
	}
	
	private function get_flatten() : ISet<K, V> {
		return nil.set();
	}
	
	private function get_iterator() : Iterator<Dynamic> {
		// FIXME
		return null;//new NilIterator<Dynamic>();
	}
	
	override private function get_productArity() : Int {
		return 0;
	}

	override private function get_productPrefix() : String {
		return "HashMap";
	}
}
