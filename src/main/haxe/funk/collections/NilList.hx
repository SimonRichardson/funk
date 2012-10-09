package funk.collections;

import funk.collections.IList;
import funk.collections.mutable.List;
import funk.collections.mutable.Nil;
import funk.errors.ArgumentError;
import funk.errors.NoSuchElementError;
import funk.errors.RangeError;
import funk.product.Product;
import funk.product.ProductIterator;
import funk.option.Option;
import funk.tuple.Tuple2;

using funk.collections.mutable.Nil;
using funk.option.Option;
using funk.tuple.Tuple2;

class NilList<T> extends Product, implements IList<T> {
	
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
	
	private var _factory : IListFactory<T>;
	
	public function new(factory : IListFactory<T>) {
		super();
		
		_factory = factory;
	}
	
	public function contains(value : T) : Bool {
		return false;
	}
	
	public function count(f : (T -> Bool)) : Int {
		return 0;
	}
	
	public function drop(n : Int) : IList<T> {
		if(n < 0){
			throw new ArgumentError("n must be positive");
		}
		
		return _factory.createNilList();
	}
	
	public function dropRight(n : Int) : IList<T> {
		if(n < 0){
			throw new ArgumentError("n must be positive");
		}
		
		return _factory.createNilList();
	}
	
	public function dropWhile(f : (T -> Bool)) : IList<T> {
		return _factory.createNilList();
	}
	
	public function exists(f : (T -> Bool)) : Bool {
		return false;
	}
	
	public function filter(f : (T -> Bool)) : IList<T> {
		return _factory.createNilList();
	}
	
	public function filterNot(f : (T -> Bool)) : IList<T> {
		return _factory.createNilList();
	}
	
	public function find(f : (T -> Bool)) : Option<T> {
		return None;
	}
	
	public function flatMap(f : (T -> IList<T>)) : IList<T> {
		return _factory.createNilList();
	}
	
	public function foldLeft(x : T, f : (T -> T -> T)) : T {
		return x;
	}
	
	public function foldRight(x : T, f : (T -> T -> T)) : T {
		return x;
	}
	
	public function forall(f : (T -> Bool)) : Bool {
		return false;
	}
	
	public function foreach(f : (T -> Void)) : Void {
	}
	
	public function get(index : Int) : Option<T> {
		return None;
	}
	
	public function map<E>(f : (T -> E)) : IList<E> {
		return cast _factory.createNilList();
	}
	
	public function partition(f : (T -> Bool)) : ITuple2<IList<T>, IList<T>> {
		return tuple2(_factory.createNilList(), _factory.createNilList()).instance();
	}
	
	public function prepend(value : T) : IList<T> {
		return _factory.createList(value, this);
	}
	
	public function prependAll(value : IList<T>) : IList<T> {
		return value;
	}
	
	public function reduceLeft(f : (T -> T -> T)) : Option<T> {
		return None;
	}
	
	public function reduceRight(f : (T -> T -> T)) : Option<T> {
		return None;
	}
	
	public function take(n : Int) : IList<T> {
		if(n < 0){
			throw new ArgumentError("n must be positive");
		}
		
		return _factory.createNilList();
	}
	
	public function takeRight(n : Int) : IList<T> {
		if(n < 0){
			throw new ArgumentError("n must be positive");
		}
		
		return _factory.createNilList();
	}
	
	public function takeWhile(f : (T -> Bool)) : IList<T> {
		return _factory.createNilList();
	}
	
	public function zip(that : IList<T>) : IList<ITuple2<T, T>> {
		return cast _factory.createNilList();
	}
	
	public function findIndexOf(f: (T -> Bool)): Int {
		return -1;
	}
	
	public function indexOf(value : T) : Int {
		return -1;
	}
	
	public function prependIterator(iterator : Iterator<T>) : IList<T> {
		return iterator.toList();
	}
	
	public function prependIterable(iterable : Iterable<T>) : IList<T> {
		return iterable.iterator().toList();
	}
	
	public function append(value : T) : IList<T> {
		return _factory.createList(value, this);
	}

	public function appendAll(value : IList<T>) : IList<T> {
		return value;
	}

	public function appendIterator(iterator : Iterator<T>) : IList<T> {
		return iterator.toList();
	}

	public function appendIterable(iterable : Iterable<T>) : IList<T> {
		return iterable.iterator().toList();
	}
	
	override public function productElement(i : Int) : Dynamic {
		throw new RangeError();
	}
	
	override public function iterator() : IProductIterator<Dynamic> {
		return new NilIterator<Dynamic>(_factory);
	}
	
	private function get_nonEmpty() : Bool {
		return false;
	}
	
	public function get_isEmpty() : Bool {
		return true;
	}
	
	private function get_head() : T {
		return null;
	}
	
	private function get_headOption() : Option<T> {
		return None;
	}
	
	private function get_indices() : IList<Int> {
		return cast _factory.createNilList();
	}
	
	private function get_init() : IList<T> {
		return _factory.createNilList();
	}
	
	private function get_last() : Option<T> {
		return None;
	}
	
	private function get_reverse() : IList<T> {
		return _factory.createNilList();
	}
	
	private function get_tail() : IList<T> {
		return null;
	}
	
	private function get_tailOption() : Option<IList<T>> {
		return None;
	}
	
	private function get_zipWithIndex() : IList<ITuple2<T, Int>> {
		return cast _factory.createNilList();
	}
	
	private function get_size() : Int {
		return 0;
	}
	
	private function get_hasDefinedSize() : Bool {
		return true;
	}

	private function get_toArray() : Array<T> {
		return new Array<T>();
	}
	
	private function get_flatten() : IList<T> {
		return _factory.createNilList();
	}
	
	override private function get_productArity() : Int {
		return 0;
	}

	override private function get_productPrefix() : String {
		return "Nil";
	}
}