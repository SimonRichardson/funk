package funk.types.extensions;

import funk.Funk;
import funk.types.Function0;

class Ints {

    public static function abs(value : Int) : Int {
        return value < 0 ? -value : value;
    }

    public static function max(a : Int, b : Int) : Int {
        return a > b ? a : b;
    }

    public static function min(a : Int, b : Int) : Int {
        return a < b ? a : b;
    }

    public static function equals(a : Int, b : Int) : Bool {
        return a == b;
    }

    public static function inRange(value : Int, min : Int, max : Int) : Bool {
        return value >= min && value < max;
    }

    public static function range(start : Int, end : Int) : Iterator<Int> {
        var assending = start >= end;
        var iterator = {
            hasNext: function() {
                return assending ? start < end : start > end;
            },
            next: null
        };
        iterator.next = function() {
            if (!iterator.hasNext()) {
                throw Errors.NoSuchElementError;
            }
            return assending ? start++ : start--;
        };
        return iterator;
    }
}
