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

	
	private static var MAX_ITERATIONS : Int = 99999;

	public static function foldLeft<T>(collection : Collection<T>, value : T, func : Function2<T, T, T>) : Future<T> {
		
		var deferred = new Deferred<T>();
		var future = deferred.future();

		#if (cpp || neko)

		// We aim to be parallel, but we don't guarantee it!
		if (collection.size() < MAX_ITERATIONS) {
			deferred.resolve(Collections.foldLeft(collection, value, func));
		} else {

			var buckets = generate(collection);
			var bucketTotal = buckets.length;
		
			// Have a slot ready for each thread.
			var slots = new Array<{result : T}>();
			
			// Make a master thread to see when things have finished		
			var master = Thread.create(function () {
				var shouldStop = false;
				while (!shouldStop) {
					// Sleep so we don't max out the cpu
					Sys.sleep(0.001);

					// Now finish
					var total = 0;
					for (item in slots) {
						if (item == null) {
							break;
						}
						total++;
					}

					if (total == bucketTotal) {
						var result = slots[0].result;
						for(i in 1...slots.length) {
							result = func(result, slots[i].result);
						}

						deferred.resolve(result);	

						shouldStop = true;
					}
				}
			});
			
			// Go through and fold as much as possible
			for (i in 0...bucketTotal) {
				Thread.create(function () {
					// Actual folding here.
					var init = i == 0;

					var result = init ? value : buckets[i][0];
					
					for(j in (init ? 0 : 1)...buckets[i].length) {
						result = func(result, buckets[i][j]);
					}

					slots[i] = {
						result: result
					};
				});
			}
		}

		#else 
		// Just reference the collections non-parallel one for unsupported targets.
		deferred.resolve(Collections.foldLeft(collection, value, func));
		#end

		return future;
	}

	private static function generate<T>(collection : Collection<T>) : Array<Array<T>> {
		var pointer = 0;
		var result = new Array<Array<T>>();
		result[pointer] = [];

		// Note (Simon) : It would be good to remove this, as I'm pretty sure that it would be better with pointer/ref
		var counter = 0;
		for(item in collection.iterator()){
			result[pointer].push(item);
			
			if (++counter == MAX_ITERATIONS) {
				result[++pointer] = [];
				counter = 0;
			}
		}

		return result;
	}
}
