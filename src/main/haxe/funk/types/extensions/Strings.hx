package funk.types.extensions;

import funk.Funk;

class Strings {

    public static function isEmpty(value : String) : Bool {
        return value == null || value.length < 1;
    }

    public static function isNonEmpty(value : String) : Bool {
        return !isEmpty(value);
    }

    public static function isEmptyOrBlank(value : String) : Bool {
        return isEmpty(StringTools.trim(value));
    }

    public static function isNonEmptyOrBlank(value : String) : Bool {
        return isNonEmpty(StringTools.trim(value));
    }

    public static function identity() : String {
        return "";
    }

    public static function map<R>(value : String, func : Function1<String, R>) : R {
        return func(value);
    }

    public static function dashesToCamelCase(value : String, ?capitaliseFirst : Bool = false) : String {
        var regexp = new EReg("-([a-z])", "g");
        var result = regexp.map(value, function (pattern) {
            return pattern.matched(1).toUpperCase();
        });
        return if (capitaliseFirst) {
            result.substr(0, 1).toUpperCase() + result.substr(1);
        } else result;
    }

    public static function camelCaseToDashes(value : String) : String {
        var regexp = new EReg("([a-zA-Z])(?=[A-Z])", "g");
        return regexp.replace(value, "$1-");
    }

    public static function camelCaseToLowerCase(value : String, ?separator : String = "_") : String {
        var reg = new EReg("([^\\A])([A-Z])", "g");
        return reg.replace(value, "$1${separator}$2").toLowerCase();
    }

    public static function camelCaseToUpperCase(value : String, ?separator : String = "_") : String {
        var reg = new EReg("([^\\A])([A-Z])", "g");
        return reg.replace(value, "$1${separator}$2").toUpperCase();
    }

    public static function iterator(value : String) : Iterator<String> {
        var index = 0;
        return {
            hasNext: function() {
                return index < value.length;
            },
            next: function() {
                return if (index < value.length) {
                    value.substr(index++, 1);
                } else {
                    Funk.error(NoSuchElementError);
                }
            }
        };
    }
}
