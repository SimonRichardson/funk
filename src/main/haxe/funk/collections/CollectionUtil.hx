package funk.collections;

import Type;
import funk.Funk;
import funk.collections.Collection;
import funk.types.extensions.Strings;
import funk.types.Function0;
import funk.types.Option;
import funk.reactives.Behaviour;
import funk.reactives.Process;
import funk.reactives.Stream;

using funk.collections.immutable.List;
using Lambda;

class CollectionUtil {

	inline private static var NAME : String = 'Collection';

	inline private static var REFLECT_NAME : String = '__reflect__';

	inline public static function zero<T>() : CollectionType<T> {
		var core : Array<T> = [];
		return {
			iterator: function() return core.iterator(),
			size: function() return core.length
		};
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

	public static function toStream<T>(collection: Collection<T>, time: Behaviour<Int>) : Stream<T> {
		var startTime = -1.0;
		var accumulation = 0;

		if(collection.size() < 1) {
			return StreamTypes.zero();
		}

		var task : Option<Task> = None;
		var pulser : Function0<Void> = null;
		var stream : Stream<T> = StreamTypes.identity(None);

		var iterator = collection.iterator();

		var create : Function0<Option<Task>> = function() {
			task = Process.stop(task);

			var nowTime = Process.stamp();

			if(startTime < 0) {
				startTime = nowTime;
			}

			var delta = time.value();
			var endTime = startTime + accumulation + delta;
			var timeToWait = endTime - nowTime;

			accumulation += delta;

			return if(timeToWait < 0) {
				pulser();
				None;
			} else {
				Process.start(pulser, timeToWait);
			}
		};

		pulser = function() {
			var next = iterator.next();

			stream.dispatch(next);

			task = Process.stop(task);

			if(iterator.hasNext()) {
				task = create();
			}
		};

		task = create();

		return stream;
	}
}
