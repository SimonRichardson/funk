package funk.collections;

import funk.Funk;
import funk.collections.IList;
import funk.collections.IteratorUtil;
import funk.errors.ArgumentError;
import funk.errors.NoSuchElementError;
import funk.errors.RangeError;
import funk.product.Product;
import funk.product.ProductIterator;
import funk.option.Option;
import funk.tuple.Tuple2;

using funk.collections.IteratorUtil;
using funk.option.Option;
using funk.tuple.Tuple2;

class NilMap<K, V> extends Product, implements IMap<K, V> {

	public var nonEmpty(get_nonEmpty, never): Bool;
	
	public var flatten(get_flatten, never): IMap<K, V>;
	
	public var hasDefinedSize(get_hasDefinedSize, never) : Bool;
	
	public var head(get_head, never): ITuple2<K, V>;

	public var headOption(get_headOption, never): IOption<ITuple2<K, V>>;

	public var init(get_init, never): IMap<K, V>;

	public var isEmpty(get_isEmpty, never): Bool;

	public var last(get_last, never): IOption<ITuple2<K, V>>;
	
	public var size(get_size, never) : Int;
	
	public var tail(get_tail, never): IMap<K, V>;
	
	public var tailOption(get_tailOption, never): IOption<IMap<K, V>>;
	
	public var toArray(get_toArray, never) : Array<ITuple2<K, V>>;
	
	public var zipWithIndex(get_zipWithIndex, never): IMap<ITuple2<K, V>, Int>;
	
	private var _factory : IMapFactory<K,V>;
	
	public function new(factory : IMapFactory<K,V>) {
		super();
		
		_factory = factory;
	}
	
	public function contains(value : K) : Bool {
	  	return false;
	}
	
	public function count(f : Function2<K, V, Bool>) : Int {
	  	return 0;
	}
	
	public function drop(n : Int) : IMap<K, V> {
		if(n < 0){
			throw new ArgumentError("n must be positive");
		}
		
	  	return _factory.createNilMap();
	}
	
	public function dropRight(n : Int) : IMap<K, V> {
		if(n < 0){
			throw new ArgumentError("n must be positive");
		}
		
		return _factory.createNilMap();
	}
	
	public function dropWhile(f : Function2<K, V, Bool>) : IMap<K, V> {
		return _factory.createNilMap();
	}
	
	public function exists(f : Function2<K, V, Bool>) : Bool {
	  	return false;
	}
	
	public function filter(f : Function2<K, V, Bool>) : IMap<K, V> {
		return _factory.createNilMap();
	}
	
	public function filterNot(f : Function2<K, V, Bool>) : IMap<K, V> {
		return _factory.createNilMap();
	}
	
	public function find(f : Function2<K, V, Bool>) : IOption<ITuple2<K, V>> {
	  	return None.toInstance();
	}
	
	public function flatMap(f : Function1<ITuple2<K, V>, IMap<K, V>>) : IMap<K, V> {
	  	return _factory.createNilMap();
	}
	
	public function foldLeft(x : ITuple2<K, V>, f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>) : ITuple2<K, V> {
	  	return x;
	}
	
	public function foldRight(x : ITuple2<K, V>, f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>) : ITuple2<K, V> {
	  	return x;
	}
	
	public function forall(f : Function2<K, V, Bool>) : Bool {
	  	return false;
	}
	
	public function foreach(f : Function2<K, V, Void>) : Void {
	}
	
	public function get(index : Int) : IOption<ITuple2<K, V>> {
		return None.toInstance();
	}
	
	public function map(f : Function1<ITuple2<K, V>, ITuple2<K, V>>) : IMap<K, V> {
		return _factory.createNilMap();
	}
	
	public function partition(f : Function2<K, V, Bool>) : ITuple2<IMap<K, V>, IMap<K, V>> {
		return tuple2(_factory.createNilMap(), _factory.createNilMap()).toInstance();
	}
	
	public function add(key : K, value : V) : IMap<K, V> {
		return _factory.createMap(tuple2(key, value).toInstance(), this);
	}
	
	public function addAll(value : IMap<K, V>) : IMap<K, V> {
		return value;
	}
	
	public function reduceLeft(f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>) : IOption<ITuple2<K, V>> {
		return None.toInstance();
	}
	
	public function reduceRight(f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>) : IOption<ITuple2<K, V>> {
		return None.toInstance();
	}
	
	public function take(n : Int) : IMap<K, V> {
		if(n < 0){
			throw new ArgumentError("n must be positive");
		}
		
		return _factory.createNilMap();
	}
	
	public function takeRight(n : Int) : IMap<K, V> {
		if(n < 0){
			throw new ArgumentError("n must be positive");
		}
		
		return _factory.createNilMap();
	}
	
	public function takeWhile(f : Function1<ITuple2<K, V>, Bool>) : IMap<K, V> {
		return _factory.createNilMap();
	}
	
	public function zip<K1, V1>(that : IMap<K1, V1>) : IMap<ITuple2<K, V>, ITuple2<K1, V1>> {
		return cast _factory.createNilMap();
	}
	
	public function addIterator(iterator : Iterator<ITuple2<K, V>>) : IMap<K, V> {
		return addAll(iterator.toMap());
	}
	
	public function addIterable(iterable : Iterable<ITuple2<K, V>>) : IMap<K, V> {
		return addAll(iterable.iterator().toMap());
	}
	
	override public function productElement(i : Int) : Dynamic {
		throw new RangeError();
	}

	override public function productIterator() : IProductIterator<Dynamic> {
		return new MapIterator<K, V>(this, this);
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
	
	private function get_headOption() : IOption<ITuple2<K, V>> {
		return None.toInstance();
	}
	
	private function get_init() : IMap<K, V> {
		return _factory.createNilMap();
	}
	
	private function get_last() : IOption<ITuple2<K, V>> {
		return None.toInstance();
	}
		
	private function get_tail() : IMap<K, V> {
		return null;
	}
	
	private function get_tailOption() : IOption<IMap<K, V>> {
		return None.toInstance();
	}
	
	private function get_zipWithIndex() : IMap<ITuple2<K, V>, Int> {
		return cast _factory.createNilMap();
	}
	
	private function get_size() : Int {
		return 0;
	}
	
	private function get_hasDefinedSize() : Bool {
		return true;
	}

	private function get_toArray() : Array<ITuple2<K, V>> {
		return [];
	}
	
	private function get_flatten() : IMap<K, V> {
		return _factory.createNilMap();
	}
		
	override private function get_productArity() : Int {
		return 0;
	}

	override private function get_productPrefix() : String {
		return "Nil";
	}
}