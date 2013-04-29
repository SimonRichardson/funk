package funk.ds.immutable;

import funk.Funk;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Any;
import funk.types.Option;
import funk.types.extensions.EnumValues;
import funk.types.extensions.Strings;

using funk.ds.Collection;
using funk.ds.immutable.List;

class ListUtil {

    public static function fill<T>(amount : Int) : Function1<Function0<T>, List<T>> {
        return function (func : Function0<T>) : List<T> {
            var list = Nil;
            while(--amount > -1) {
                list = list.prepend(func());
            }
            return list.reverse();
        };
    }

    public static function toList<T1, T2>(any : T1) : List<T2> {
        var result = Nil;

        switch(Type.typeof(any)) {
            case TObject:
                if (AnyTypes.isInstanceOf(any, Array)) {
                    result = arrayToList(cast any);
                } else if (AnyTypes.isInstanceOf(any, String)) {
                    result = stringToList(cast any);
                }
            case TEnum(e):
                if (e == ListType) {
                    result = cast any;
                }
            case TClass(c):
                if (c == Array) {
                    result = arrayToList(cast any);
                } else if (c == String) {
                    result = stringToList(cast any);
                }
            case _:
        }

        if (result.isEmpty()) {
            result = anyToList(cast any);
        }

        return cast result;
    }

    private static function anyToList<T>(any : T) : List<T> {
        return Nil.append(any);
    }

    private static function arrayToList<T>(array : Array<T>) : List<T> {
        var list = Nil;

        for (item in array) {
            list = list.append(item);
        }

        return list;
    }

    private static function stringToList<T>(string : String) : List<String> {
        var list : List<String> = Nil;

        for (item in Strings.iterator(string)) {
            var string : String = item;

            list = list.append(string);
        }

        return list;
    }
}
