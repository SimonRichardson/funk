package funk.collections;

import funk.product.Product2;
import funk.option.Option;
import funk.tuple.Tuple2;

interface ISet<K, V> implements IProduct2<K, V>, implements ICollection<V> {

    var nonEmpty(dynamic, never): Bool;
	
    var flatten(dynamic, never): ISet<K, V>;
	
    var head(dynamic, never): ITuple2<K, V>;

	var headOption(dynamic, never): Option<ITuple2<K, V>>;

    var init(dynamic, never): ISet<K, V>;

    var isEmpty(dynamic, never): Bool;

    var last(dynamic, never): Option<ITuple2<K, V>>;
	
    var tail(dynamic, never): ISet<K, V>;
	
	var tailOption(dynamic, never): Option<ISet<K, V>>;
	
	var zipWithIndex(dynamic, never): ISet<ITuple2<K, V>, Int>;
	
    function contains(value: K): Bool;

    function count(f: (ITuple2<K, V> -> Bool)): Int;

    function drop(n: Int): ISet<K, V>;

    function dropRight(n: Int): ISet<K, V>;

    function dropWhile(f: (ITuple2<K, V> -> Bool)): ISet<K, V>;

    function exists(f: (ITuple2<K, V> -> Bool)): Bool;

    function filter(f: (ITuple2<K, V> -> Bool)): ISet<K, V>;

    function filterNot(f: (ITuple2<K, V> -> Bool)): ISet<K, V>;

    function find(f: (ITuple2<K, V> -> Bool)): Option<ITuple2<K, V>>;

    function flatMap(f: (ITuple2<K, V> -> ISet<K, V>)): ISet<K, V>;

    function foldLeft(x: ITuple2<K, V>, f: (ITuple2<K, V> -> ITuple2<K, V> -> ITuple2<K, V>)): ITuple2<K, V>;

    function foldRight(x: ITuple2<K, V>, f: (ITuple2<K, V> -> ITuple2<K, V> -> ITuple2<K, V>)): ITuple2<K, V>;

    function forall(f: (ITuple2<K, V> -> Bool)): Bool;

    function foreach(f: (ITuple2<K, V> -> Void)): Void;

    function get(index: Int): Option<V>;

    function map(f: (ITuple2<K, V> -> ITuple2<K, V>)): ISet<K, V>;

    function partition(f: (ITuple2<K, V> -> Bool)): ITuple2<ISet<K, V>, ISet<K, V>>;

    function add(value: ITuple2<K, V>): ISet<K, V>;

    function addAll(value: ISet<K, V>): ISet<K, V>;

    function addIterator(iterator: Iterator<ITuple2<K, V>>): ISet<K, V>;

    function addIterable(iterable: Iterable<ITuple2<K, V>>): ISet<K, V>;

    function reduceLeft(f: (ITuple2<K, V> -> ITuple2<K, V> -> ITuple2<K, V>)): Option<ITuple2<K, V>>;

    function reduceRight(f: (ITuple2<K, V> -> ITuple2<K, V> -> ITuple2<K, V>)): Option<ITuple2<K, V>>;
	
    function take(n: Int): ISet<K, V>;

    function takeRight(n: Int): ISet<K, V>;

    function takeWhile(f : (ISet<K, V> -> Bool)) : ISet<K, V>;

    function zip(that: ISet<Dynamic, Dynamic>): ISet<ITuple2<K, V>, ITuple2<Dynamic, Dynamic>>;
}
