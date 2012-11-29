package funk.collections.extensions;

import funk.collections.Collection;

class CollectionsUtil {

	public static function toCollection<T>(x : T) : Collection<T> {
		var valueType : ValueType = Type.typeof(x);

		switch (valueType) {
			case TObject:
			case TClass:
			default:
		}

		return {
			__reflect__: {
				id: 'Collection',
				type: valueType,
				origin: x
			},
			iterator: iterator,
			size: function() {
				return size;
			}
		}
	}
}
