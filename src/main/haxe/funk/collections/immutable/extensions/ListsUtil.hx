package funk.collections.immutable.extensions;

import funk.Funk;
import funk.collections.extensions.Collections;
import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;
import funk.types.Function0;
import funk.types.Option;
import funk.types.extensions.Strings;

using funk.collections.immutable.extensions.Lists;

class ListsUtil {

	public static function fill<T>(amount : Int, func : Function0<T>) : List<T> {
		var list = Nil;
		while(--amount > -1) {
			list = list.prepend(func());
		}
		return list.reverse();
	}

	public static function toList<T1, T2>(any : T1) : List<T2> {
		var arrayToList = function(array : Array<T2>) {
			var list = Nil;

			for (item in array) {
				list = list.append(item);
			}

			return list;
		};

		var stringToList = function(string : String) {
			var list = Nil;

			for (item in Strings.iterator(string)) {
				list = list.append(cast item);
			}

			return list;
		};

		switch(Type.typeof(any)) {
			case TEnum(e):
				if (e == List) {
					return cast any;
				} else {
					Funk.error(Errors.ArgumentError());
				}
			case TObject:
				if (Std.is(any, Array)) {
					return arrayToList(cast any);
				} else if (Std.is(any, String)) {
					return stringToList(cast any);
				} else {
					Funk.error(Errors.ArgumentError());
				}
			case TClass(c):
				if (c == Array) {
					return arrayToList(cast any);
				} else if (c == String) {
					return stringToList(cast any);
				} else {
					Funk.error(Errors.ArgumentError());	
				}
			default:
				Funk.error(Errors.ArgumentError());
		}

		return Nil.append(cast any);
	}

}
