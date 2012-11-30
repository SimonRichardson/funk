package funk.collections.extensions;

import Type;
import funk.Funk;
import funk.collections.Collection;
import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;
import funk.types.extensions.Strings;

using funk.collections.immutable.extensions.Lists;

class CollectionsUtil {

	inline private static var NAME : String = 'Collection';

	inline private static var REFLECT_NAME : String = '__reflect__';

	public static function zero<T>() : Collection<T> {
		// TODO (Simon) : We could optimise this.
		return toCollection([]);
	}

	public static function toCollection<T, R>(x : T) : Collection<R> {
		var valueType : ValueType = Type.typeof(x);

		var size : Int = 0;
		var iterable : Iterable<R> = null;

		switch (valueType) {
			case TEnum(e):
				if (e == List) {
					return (cast e).collection();
				} else {
					Funk.error(Errors.ArgumentError());
				}
			case TObject:
				if (Reflect.hasField(x, REFLECT_NAME)) {
					var reflect = Reflect.field(x, REFLECT_NAME);
					if (Reflect.field(reflect, 'id') == NAME) {
						return cast x;
					}
				} 

				Funk.error(Errors.ArgumentError());
			case TClass(c):
				if (c == Array) {
					var array : Array<R> = cast x;
					size = array.length;
					iterable = array;
				} else if (c == String) {
					var string : String = cast x;
					size = string.length;
					iterable = {
						iterator: function() {
							return cast Strings.iterator(string);
						}
					};
				} else {
					Funk.error(Errors.ArgumentError());
				}
			default:
				Funk.error(Errors.ArgumentError());
		}

		var collection : Collection<R> = {
			iterator: function () {
				return iterable.iterator();
			},
			size: function() {
				return size;
			}
		};

		Reflect.setField(collection, REFLECT_NAME, {
			id: NAME,
			type: valueType,
			origin: x
		});

		return collection;
	}
}
