package funk.ds.immutable;

using funk.ds.immutable.List;

class Range {

    inline public static function to(start : Int, end : Int) : List<Int> {
        var m = start - 1;
        var n = end + 1;

        var list = Nil;
        while(--n > m) {
            list = list.prepend(n);
        }
        return list;
    }

    inline public static function until(start : Int, end : Int) : List<Int> {
        var m = start - 1;
        var n = end;

        var list = Nil;
        while(--n > m) {
            list = list.prepend(n);
        }
        return list;
    }
}
