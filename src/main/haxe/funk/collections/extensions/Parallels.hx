package funk.collections.extensions;

import funk.Funk;
import funk.collections.Collection;
import funk.collections.extensions.Collections;
import funk.collections.extensions.CollectionsUtil;
import funk.types.Deferred;
import funk.types.Function1;
import funk.types.Function2;
import funk.types.Function3;
import funk.types.Future;
import funk.types.Option;
import funk.types.Predicate1;
import funk.types.Predicate2;
import funk.types.Tuple2;
import funk.types.extensions.Anys;
import funk.types.extensions.Iterators;

#if neko
import neko.vm.Thread;
#elseif cpp
import cpp.vm.Thread;
#end

using funk.collections.extensions.Collections;
using funk.types.extensions.Iterators;

class Parallels {

	
	private static var MAX_ITERATIONS : Int = 9999;

	public static function foldLeft<T>(collection : Collection<T>, value : T, func : Function2<T, T, T>) : Future<T> {
		
		var deferred = new Deferred<T>();
		var future = deferred.future();

		#if (cpp || neko)

		// We aim to be parallel, but we don't guarantee it!
		var size = collection.size();
		if (size < MAX_ITERATIONS) {
			deferred.resolve(Collections.foldLeft(collection, value, func));
		} else {
			// Go through and fold as much as possible
			var total = Math.ceil(Math.log(size / 2));
			var length = Math.ceil(size / total);

			var results = [];

			var actual = 0;
			var expected = total * (total + 1) / 2;

			var iterator = collection.iterator();
			for (index in 1...total + 1) {
				var items = gather(iterator, length);

				Thread.create(function () {

					var result = index == 1 ? value : items.shift();
					// Actual folding here.
					for (item in items) {
						result = func(result, item);
					}

					results[index - 1] = result;

					actual += index;

					if (actual == expected) {
						result = results.shift();

						for (item in results) {
							result = func(result, item);
						}

						deferred.resolve(result);
					}
				});
			}
		}

		#else 
		// Just reference the collections non-parallel one for unsupported targets.
		deferred.resolve(Collections.foldLeft(collection, value, func));
		#end

		return future;
	}

	private inline static function gather<T>(iterator : Iterator<T>, size : Int) : Array<T> {
		var result = [];
		var index = 0;
		while (iterator.hasNext()) {
			if (index < size) {
				result[index++] = iterator.next();
			} else if (index >= size) {
				break;
			}
		}
		return result;
	}
}
