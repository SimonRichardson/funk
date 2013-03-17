package funk.types.extensions;

import funk.Funk;
import funk.types.Function0;

class Floats {

    public static function abs(value : Float) : Float {
        return value < 0 ? -value : value;
    }

    public static function ceil(value : Float) : Float {
        return cast((value >= 0 ? value : -value) + 0.9) >>> 0;
    }

    public static function floor(value : Float) : Float {
        return cast(value) | 0;
    }

    public static function round(value : Float) : Float {
        return cast((value >= 0 ? value : -value) + 0.5) >>> 0;
    }

    public static function max(a : Float, b : Float) : Float {
        return a > b ? a : b;
    }

    public static function min(a : Float, b : Float) : Float {
        return a < b ? a : b;
    }

    public static function equals(a : Float, b : Float, ?epsilon : Null<Float> = 1e-5) : Bool {
        if (a == b) {
            return true;
        } else {
            var diff = a - b;
            return (diff >= 0.0 && diff < epsilon) || (diff <= 0.0 && diff > -epsilon);
        }
    }

    public static function inRange(value : Float, min : Float, max : Float) : Bool {
        return value >= min && value < max;
    }

    public static function range(start : Float, end : Float, ?step : Null<Float> = 1.0) : Iterator<Float> {
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
            return assending ? start += step : start -= step;
        };
        return iterator;
    }
}
