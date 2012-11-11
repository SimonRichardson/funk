package funk.collections;

import funk.Funk;
import funk.product.Product;
import funk.option.Option;
import funk.tuple.Tuple2;

interface IList<T> implements IProduct, implements ICollection<T> {

    var nonEmpty(dynamic, never) : Bool;

    var flatten(dynamic, never) : IList<T>;

    var head(dynamic, never) : T;

	var headOption(dynamic, never) : IOption<T>;

    var indices(dynamic, never) : IList<Int>;

    var init(dynamic, never) : IList<T>;

    var isEmpty(dynamic, never) : Bool;

    var last(dynamic, never) : IOption<T>;

	var reverse(dynamic, never) : IList<T>;

    var tail(dynamic, never) : IList<T>;

	var tailOption(dynamic, never) : IOption<IList<T>>;

	var zipWithIndex(dynamic, never) : IList<ITuple2<T, Int>>;

    function contains(value : T) : Bool;

    function count(f : Function1<T, Bool>) : Int;

    function drop(n : Int) : IList<T>;

    function dropRight(n : Int) : IList<T>;

    function dropWhile(f : Function1<T, Bool>) : IList<T>;

    function exists(f : Function1<T, Bool>) : Bool;

    function filter(f : Function1<T, Bool>) : IList<T>;

    function filterNot(f : Function1<T, Bool>) : IList<T>;

    function find(f : Function1<T, Bool>) : IOption<T>;

    function findIndexOf(f : Function1<T, Bool>) : Int;

    function flatMap(f : Function1<T, IList<T>>) : IList<T>;

    function foldLeft(x: T, f : Function2<T, T, T>) : T;

    function foldRight(x: T, f : Function2<T, T, T>) : T;

    function forall(f : Function1<T, Bool>) : Bool;

    function foreach(f : Function1<T, Void>) : Void;

    function get(index: Int) : IOption<T>;

    function indexOf(value : T) : Int;

    function map<E>(f : Function1<T, E>) : IList<E>;

    function partition(f : Function1<T, Bool>) : ITuple2<IList<T>, IList<T>>;

    function prepend(value : T) : IList<T>;

    function prependAll(value : IList<T>) : IList<T>;

    function prependIterator(iterator : Iterator<T>) : IList<T>;

    function prependIterable(iterable : Iterable<T>) : IList<T>;

    function append(value : T) : IList<T>;

    function appendAll(value : IList<T>) : IList<T>;

    function appendIterator(iterator : Iterator<T>) : IList<T>;

    function appendIterable(iterable : Iterable<T>) : IList<T>;

    function reduceLeft(f : Function2<T, T, T>) : IOption<T>;

    function reduceRight(f : Function2<T, T, T>) : IOption<T>;

    function take(n : Int) : IList<T>;

    function takeRight(n : Int) : IList<T>;

    function takeWhile(f : Function1<T, Bool>) : IList<T>;

    function zip(that : IList<T>) : IList<ITuple2<T, T>>;
}
