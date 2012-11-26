package funk.collections.immutable.extensions;

import funk.Funk;
import funk.collections.extensions.Collections;
import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;
import funk.types.Option;

using funk.collections.immutable.extensions.Lists;

class ListsUtil {

	public static function toList<T1, T2>(any : T1) : List<T2> {
		var list = Nil;
		return switch(Type.typeof(any)) {
			case TEnum(e):
				cast any;
			case TObject:
				if (Std.is(any, Array)) {
					var array : Array<T2> = cast any;
					for (item in array) {
						list = list.prepend(item);
					}
				} else {
					list = list.prepend(cast any);
				}
				list;
			case TClass(c):
				if (c == Array) {
					var array : Array<T2> = cast any;
					for (item in array) {
						list = list.prepend(item);
					}
				} else if (c == String) {
					var string : String = cast any;
					// TODO (Simon) : Replace with string iterator.
					var count = 0;
					var iterator = {
						hasNext: function() {
							return count < string.length;
						},
						next: function() {
							return string.substr(count++, 1);
						}
					};

					for (item in iterator) {
						list = list.prepend(cast item);
					}
				} else {
					list = list.prepend(cast any);
				}
				list;
			default:
				list = list.prepend(cast any);
				list;
		}
	}

}