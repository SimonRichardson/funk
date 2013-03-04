package funk.collections;

import Type;
import funk.Funk;
import funk.collections.Collection;
import funk.types.extensions.Strings;

using funk.collections.immutable.List;
using Lambda;

class CollectionUtil {

	inline private static var NAME : String = 'Collection';

	inline private static var REFLECT_NAME : String = '__reflect__';

	inline public static function zero<T>() : CollectionType<T> {
		// TODO (Simon) : We could optimize this.
		return toCollection([]);
	}

	public static function toCollection<T, R>(x : T) : CollectionType<R> {
		var size : Int = -1;
		var iterable : Iterable<R> = null;

		// Because array is the likely option to a collection, let's optimize this to as much as possible
		if (Std.is(x, Array)) {
			var array : Array<R> = cast x;
			size = array.length;
			iterable = array;
		} else {
			// Now do the switch over the value type.
			switch (Type.typeof(x)) {
				case TEnum(e):
					if (e == ListType) {
						return (cast e).collection();
					}

				case TObject:
					if (Reflect.hasField(x, REFLECT_NAME)) {
						var reflect = Reflect.field(x, REFLECT_NAME);
						if (Reflect.field(reflect, 'id') == NAME) {
							return cast x;
						}
					}

				case TClass(c):
					if (c == String) {
						var string : String = cast x;
						size = string.length;
						iterable = {
							iterator: function() {
								return cast Strings.iterator(string);
							}
						};
					} else {
						var instanceFields : Array<String> = Type.getInstanceFields(c);
						if (instanceFields.indexOf('size') >= 0 && instanceFields.indexOf('iterator') >= 0) {
							// We have a possible match
							return cast x;
						}
					}
				case _:
			}

			// If none exist, create it.
			if (size == -1 && null == iterable) {
				iterable = cast [x];
				size = 1;
			}
		}

		var collection : Collection<R> = {
			iterator: function () {
				return iterable.iterator();
			},
			size: function() {
				return size;
			}
		};

		// TODO (Simon) : If this is going to be just id, then flatten it.
		Reflect.setField(collection, REFLECT_NAME, {
			id: NAME
		});

		return collection;
	}
}
