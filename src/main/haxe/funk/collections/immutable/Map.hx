package funk.collections.immutable;

import funk.collections.immutable.ListUtil;
import funk.types.Any;
import funk.types.Function1;
import funk.types.Predicate1;
import haxe.ds.ObjectMap;

using funk.types.Option;
using funk.types.Tuple2;

/**
 * Usage : var map = Empty.add('key', 'value');
*/
enum Map<K : String, V> {
    Node(map : StringMap<V>, key : K, value : V);
    Empty;
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
        trace(key);
        return switch (map) {
            case Node(_, k, _) if(k == key): true;
            case Node(m, _, _): m.exists(key);
            case _: false;
        }
    }

    public static function get<K : String, V>(map : Map<K, V>, key : K) : Option<V> {
        return switch (map) {
            case Node(_, k, v) if(k == key): Some(v);
            case Node(m, _, _): OptionTypes.toOption(m.get(key));
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
        return ListUtil.toList(nativeKeys(map));
    }

    public static function map<K1 : String, V1, K2 : String, V2>(   map : Map<K1, V1>, 
                                                                    func : Function1<Tuple2<K1, V1>, Tuple2<K2, V2>>
                                                                    ) : Map<K2, V2> {
        var result = Empty;
        for(i in nativeKeys(map)) {
            var f = func(tuple2(i, nativeGet(map, i)));
            result = add(result, f._1(), f._2());
        }
        return result;
    }   

    public static function remove<K : String, V>(map : Map<K, V>, key : K) : Map<K, V> {
        var result = Empty;
        for(i in nativeKeys(map)) {
            if(i != key) {
                result = add(result, i, nativeGet(map, i));
            }
        }
        return result;
    }

    public static function isEmpty<K : String, V>(map : Map<K, V>) : Bool {
        return switch(map) {
            case Node(_, _, _): false;
            case _: true;
        }
    }

    public static function nonEmpty<K : String, V>(map : Map<K, V>) : Bool {
        return !isEmpty(map);
    }

    public static function toString<K : String, V>(map : Map<K, V>, ?func : Function1<Tuple2<K, V>, String>) : String {
        var p = map;
        return switch(p) {
            case Node(_, _, _): 'Map';
            case _: 'Empty';
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
        trace(result);
        return result;
    }

    private static function nativeKeys<K : String, V>(map : Map<K, V>) : Iterator<K> {
        return switch(map) {
            case Node(m, _, _): m.keys();
            case _: [].iterator();
        }
    }

    private static function nativeGet<K : String, V>(map : Map<K, V>, key : K) : V {
        return switch (map) {
            case Node(m, _, _): 
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
            case Node(map, _, _):
                var m = nativeClone(map);
                m = func(m);
                Node(m, key, value);
            case _: 
                var m = new StringMap();
                m.set(key, value);
                Node(m, key, value);
        }
    }
}
