package funk.ds.immutable;

import funk.ds.Collection;
import funk.ds.immutable.ListUtil;
import funk.types.Any;
import funk.types.Function1;
import funk.types.Predicate1;
import haxe.ds.StringMap;

using funk.ds.immutable.List;
using funk.types.Option;
using funk.types.Tuple2;

/**
 * Usage : var map = Empty.add('key', 'value');
*/
enum MapType<K : String, V> {
    Nil;
    Cons(key : K, value : V, map : StringMap<V>);
}

abstract Map<K : String, V>(MapType<K, V>) from MapType<K, V> to MapType<K, V> {

    inline function new(map : MapType<K, V>) {
        this = map;
    }

    inline public function iterator() : Iterator<Tuple2<K, V>> return MapTypes.iterator(this);

    @:to
    inline public static function toMap<K : String, V>(map : MapType<K, V>) : StringMap<V> return MapTypes.toMap(map);

    @:to
    inline public static function toArray<K : String, V>(map : MapType<K, V>) : Array<Tuple2<K, V>> {
        var stack = [];
        for(i in MapTypes.iterator(map)) stack.push(i);
        return stack;
    }

    @:to
    inline public static function toCollection<K : String, V>(map : MapType<K, V>) : Collection<Tuple2<K, V>> {
        return MapTypes.collection(map);
    }

    @:to
    inline public static function toString<K : String, V>(map : MapType<K, V>) : String return MapTypes.toString(map);
}

class MapTypes {

    public static function add<K : String, V>(map : Map<K, V>, key : K, value : V) : Map<K, V> {
        return nativeMap(map, key, value, function(m) {
            m.set(key, value);
            return m;
        });
    }

    public static function addAll<K : String, V>(map : Map<K, V>, maps : Map<K, V>) : Map<K, V> {
        foreach(maps, function(tuple : Tuple2<K, V>) {
            map = add(map, tuple._1(), tuple._2());
        });
        return map;
    }

    public static function exists<K : String, V>(map : Map<K, V>, key : K) : Bool {
        return switch (map) {
            case Cons(k, _, _) if(k == key): true;
            case Cons(_, _, m): m.exists(key);
            case _: false;
        }
    }

    public static function get<K : String, V>(map : Map<K, V>, key : K) : Option<V> {
        return switch (map) {
            case Cons(k, v, _) if(k == key): Some(v);
            case Cons(_, _, m): OptionTypes.toOption(m.get(key));
            case _: None;
        }
    }

    public static function forall<K : String, V>(map : Map<K, V>, func : Predicate1<Tuple2<K, V>>) : Bool {
        var result = false;
        for(i in nativeKeys(map)) {
            if(func(tuple2(i, nativeGet(map, i)))){
                result = true;
                break;
            }
        }
        return result;
    }

    public static function foreach<K : String, V>(map : Map<K, V>, func : Function1<Tuple2<K, V>, Void>) : Void {
        for(i in nativeKeys(map)) {
            func(tuple2(i, nativeGet(map, i)));
        }
    }

    public static function indices<K : String, V>(map : Map<K, V>) : List<K> {
        return ListType.Nil.prependIterator(nativeKeys(map));
    }

    public static function values<K : String, V>(map : Map<K, V>) : List<V> {
        return ListType.Nil.prependIterator(nativeValues(map));
    }

    public static function map<K1 : String, V1, K2 : String, V2>(   map : Map<K1, V1>,
                                                                    func : Function1<Tuple2<K1, V1>, Tuple2<K2, V2>>
                                                                    ) : Map<K2, V2> {
        var result = Nil;
        for(i in nativeKeys(map)) {
            var f = func(tuple2(i, nativeGet(map, i)));
            result = add(result, f._1(), f._2());
        }
        return result;
    }

    public static function remove<K : String, V>(map : Map<K, V>, key : K) : Map<K, V> {
        var result = Nil;
        for(i in nativeKeys(map)) {
            if(i != key) {
                result = add(result, i, nativeGet(map, i));
            }
        }
        return result;
    }

    public static function isEmpty<K : String, V>(map : Map<K, V>) : Bool {
        return switch(map) {
            case Cons(_, _, _): false;
            case _: true;
        }
    }

    public static function nonEmpty<K : String, V>(map : Map<K, V>) : Bool return !isEmpty(map);

    public static function collection<K : String, V>(map : Map<K, V>) : Collection<Tuple2<K, V>> {
        return new MapInstanceImpl(map);
    }

    public static function toMap<K : String, V>(map : Map<K, V>) : StringMap<V> {
        return switch(map) {
            case Cons(_, _, m): m;
            case _: new StringMap();
        }
    }

    public static function list<K : String, V>(map : Map<K, V>) : List<Tuple2<K, V>> {
        var result = ListType.Nil;
        MapTypes.foreach(map, function(value) result = result.prepend(value));
        return result;
    }

    inline public static function iterable<K : String, V>(map : Map<K, V>) : Iterable<Tuple2<K, V>> {
        return new MapInstanceImpl(map);
    }

    inline public static function iterator<K : String, V>(map : Map<K, V>) : Iterator<Tuple2<K, V>> {
        return iterable(map).iterator();
    }

    public static function toString<K : String, V>(map : Map<K, V>, ?func : Function1<Tuple2<K, V>, String>) : String {
        var p = map;
        return switch(p) {
            case Cons(_, _, _):
                var mappedFunc : Function1<Tuple2<K, V>, String> = AnyTypes.toBool(func) ? func : function(tuple) {
                    return '${tuple._1()} => ${tuple._2()}';
                };
                var mapped : Collection<String> = CollectionTypes.map(collection(p), function(value) {
                    return AnyTypes.toString(value, mappedFunc);
                });
                var folded : Option<String> = CollectionTypes.foldLeftWithIndex(mapped, '', function(a, b, index) {
                    return index < 1 ? b : '$a, $b';
                });
                'Map(${folded.get()})';
            case _: 'Nil';
        }
    }


    /**
     * Private methods to make working with a map more easier.
     */

    private static function nativeClone<K : String, V>(map : StringMap<V>) : StringMap<V> {
        // Surely this can be optimized.
        var result = new StringMap();
        for(i in map.keys()) {
            result.set(i, map.get(i));
        }
        return result;
    }

    private static function nativeKeys<K : String, V>(map : Map<K, V>) : Iterator<K> {
        return switch(map) {
            case Cons(_, _, m): m.keys();
            case _: [].iterator();
        }
    }

    private static function nativeValues<K : String, V>(map : Map<K, V>) : Iterator<V> {
        return switch(map) {
            case Cons(_, _, m): m.iterator();
            case _: [].iterator();
        }
    }

    private static function nativeGet<K : String, V>(map : Map<K, V>, key : K) : V {
        return switch (map) {
            case Cons(_, _, m):
                var v = m.get(key);
                AnyTypes.toBool(v) ? v : Funk.error(NoSuchElementError);
            case _: Funk.error(NoSuchElementError);
        }
    }

    private static function nativeMap<K : String, V>(   map : Map<K, V>,
                                                        key : K,
                                                        value : V,
                                                        func : Function1<StringMap<V>, StringMap<V>>
                                                        ) : Map<K, V> {
        return switch (map) {
            case Cons(_, _, map):
                var m = nativeClone(map);
                m = func(m);
                Cons(key, value, m);
            case _:
                var m = new StringMap();
                m.set(key, value);
                Cons(key, value, m);
        }
    }
}

private class MapInstanceImpl<K : String, V> {

    private var _list : List<Tuple2<K, V>>;

    private var _knownSize : Bool;

    private var _size : Int;

    public function new(map : Map<K, V>) {
        _list = ListType.Nil;

        MapTypes.foreach(map, function(value) _list = _list.prepend(value));

        _size = 0;
        _knownSize = false;
    }

    public function iterator() : Iterator<Tuple2<K, V>> {
        var list = _list;
        return {
            hasNext: function() return ListTypes.nonEmpty(list),
            next: function() {
                return if (ListTypes.nonEmpty(list)) {
                    var value = ListTypes.head(list);
                    list = ListTypes.tail(list);
                    value;
                } else Funk.error(NoSuchElementError);
            }
        };
    }

    public function size() : Int {
        if (_knownSize) return _size;

        _size = ListTypes.size(_list);
        _knownSize = true;

        return _size;
    }
}

