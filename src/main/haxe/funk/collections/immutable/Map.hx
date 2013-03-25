package funk.collections.immutable;

import funk.types.Function1;
import funk.types.Option;
import haxe.ds.ObjectMap;

/**
 * Usage : var map = Empty.add('key', 'value');
*/

enum Map<K, V> {
    Node(map : ObjectMap<K, V>, key : K, value : V);
    Empty;
}

class MapTypes {

    public static function add<K, V>(map : Map<K, V>, key : K, value : V) : Map<K, V> {
        return nativeMap(map, key, value, function(m) return m.set(key, value); m;);
    }

    public static function exits<K, V>(map : Map<K, V>, key : K) : Bool {
        return switch (map) {
            case Node(_, k, _) if(k == key): true;
            case Node(map, _, _): map.exists(key);
            case _: false;
        }
    }

    public static function get<K, V>(map : Map<K, V>, key : K) : Option<V> {
        return switch (map) {
            case Node(_, k, v) if(k == key): Some(v);
            case Node(map, _, _): Some(map.get(key));
            case _: None;
        }
    }

    public static function remove<K, V>(map : Map<K, V>, key : K) : Map<K, V> {
        return nativeMap(map, key, value, function(m) return m.remove(key); m;);
    }

    private static function clone<K, V>(map : ObjectMap<K, V>) : ObjectMap<K, V> {
        // Surely this can be optimized.
        var result = new ObjectMap();
        for(i in map) {
            result.set(i, map[i]);
        }
        return result;
    }

    private static function nativeMap<K, V>(    map : Map<K, V>,
                                                key : K,
                                                value : V,
                                                func : Function1<ObjectMap<K, V>, ObjectMap<K, V>>
                                                ) : Map<K, V> {
        return switch (map) {
            case Node(map, _, _):
                var m = clone(map);
                m = func(m);
                Node(m, key, value);
            case _: Node(new ObjectMap(), key, value);
        }
    }
}
