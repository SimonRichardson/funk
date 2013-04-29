package funk.ds;

class IteratorUtil {

    public static function toArray<T>(iterator : Iterator<T>) : Array<T> {
        var array = [];
        while(iterator.hasNext()) {
            array.push(iterator.next());
        }
        return array;
    }
}
