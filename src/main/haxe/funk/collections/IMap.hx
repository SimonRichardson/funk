package funk.collections;

import funk.Funk;
import funk.product.Product;
import funk.option.Option;
import funk.tuple.Tuple2;

interface IMap<K, V> implements IProduct, implements ICollection<ITuple2<K, V>> {

    var head(get_head, never) : ITuple2<K, V>;

    var headOption(get_headOption, never) : IOption<ITuple2<K, V>>;

    var tail(get_tail, never) : IMap<K, V>;

    var tailOption(get_tailOption, never) : IOption<IMap<K, V>>;

	var nonEmpty(dynamic, never) : Bool;

    var flatten(dynamic, never) : IMap<K, V>;

    var isEmpty(dynamic, never) : Bool;

	var zipWithIndex(dynamic, never) : IMap<ITuple2<K, V>, Int>;

    function containsKey(key : K) : Bool;

    function containsValue(value : V) : Bool;

    function count(f : Function2<K, V, Bool>) : Int;

    function drop(n : Int) : IMap<K, V>;

    function dropRight(n : Int) : IMap<K, V>;

    function dropWhile(f : Function2<K, V, Bool>) : IMap<K, V>;

    function exists(f : Function2<K, V, Bool>) : Bool;

    function filter(f : Function2<K, V, Bool>) : IMap<K, V>;

    function filterNot(f : Function2<K, V, Bool>) : IMap<K, V>;

    function find(f : Function2<K, V, Bool>) : IOption<ITuple2<K, V>>;

    function flatMap(f : Function1<ITuple2<K, V>, IMap<K, V>>) : IMap<K, V>;

    function foldLeft(	x : ITuple2<K, V>,
    					f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>
    					) : ITuple2<K, V>;

    function foldRight(	x : ITuple2<K, V>,
    					f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>
    					): ITuple2<K, V>;

    function forall(f : Function2<K, V, Bool>) : Bool;

    function foreach(f : Function2<K, V, Void>) : Void;

    function get(key : K) : IOption<ITuple2<K, V>>;

    function map(f : Function1<ITuple2<K, V>, ITuple2<K, V>>) : IMap<K, V>;

    function partition(f : Function2<K, V, Bool>) : ITuple2<IMap<K, V>, IMap<K, V>>;

    function add(key : K, value : V) : IMap<K, V>;

    function addAll(value : IMap<K, V>) : IMap<K, V>;

    function addIterator(iterator : Iterator<ITuple2<K, V>>) : IMap<K, V>;

    function addIterable(iterable : Iterable<ITuple2<K, V>>) : IMap<K, V>;

    function reduceLeft(	f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>
    						) : IOption<ITuple2<K, V>>;

    function reduceRight(	f : Function2<ITuple2<K, V>, ITuple2<K, V>, ITuple2<K, V>>
    						) : IOption<ITuple2<K, V>>;

    function take(n : Int) : IMap<K, V>;

    function takeRight(n : Int) : IMap<K, V>;

    function takeWhile(f : Function1<ITuple2<K, V>, Bool>) : IMap<K, V>;

    function zip<K1, V1>(that : IMap<K1, V1>) : IMap<ITuple2<K, V>, ITuple2<K1, V1>>;
}
