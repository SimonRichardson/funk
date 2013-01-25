package funk.collections.immutable.extensions;

import funk.Funk;
import funk.collections.extensions.Collections;
import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Option;
import funk.types.extensions.Strings;

using funk.collections.immutable.extensions.Lists;

class ListsUtil {

	public static function fill<T>(amount : Int) : Function1<Void -> T, List<T>> {
		return function (func : Void -> T) : List<T> {
			var list = Nil;
			while(--amount > -1) {
				list = list.prepend(func());
			}
			return list.reverse();
		};
	}

	public static function toList<T1, T2>(any : T1) : List<T2> {
		return if (Std.is(any, List)) {
			cast any;
		} else {
			var result = switch(Type.typeof(any)) {
				case TObject:
					if (Std.is(any, Array)) {
						arrayToList(cast any);
					} else if (Std.is(any, String)) {
						stringToList(cast any);
					} else {
						anyToList(cast any);
					}
				case TClass(c):
					if (c == Array) {
						arrayToList(cast any);
					} else if (c == String) {
						stringToList(cast any);
					} else {
						anyToList(cast any);
					}
				default:
					anyToList(cast any);
			}
			if (!Std.is(result, List)) {
				throw "fuck a duck";
			}
			cast result;
		}
	}

	inline private static function anyToList<T>(any : T) : List<T> {
		return Nil.append(any);
	}

	inline private static function arrayToList<T>(array : Array<T>) : List<T> {
		var list = Nil;

		for (item in array) {
			list = list.append(item);
		}

		return list;
	}

	inline private static function stringToList<T>(string : String) : List<String> {
		var list = Nil;

		for (item in Strings.iterator(string)) {
			list = list.append(item);
		}

		return list;
	}
}
