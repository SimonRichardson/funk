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
import funk.types.extensions.Tuples2;

using funk.collections.extensions.Collections;
using funk.types.extensions.Iterators;
using funk.types.extensions.Tuples2;

#if neko
import neko.vm.Mutex;
import neko.vm.Thread;
#elseif cpp
import cpp.vm.Mutex;
import cpp.vm.Thread;
#end

class Parallels {

	
	private static var MAX_ITERATIONS : Int = 9999;

	public static function count<T>(collection : Collection<T>, func : Predicate1<T>) : Future<Int> {
		// We aim to be parallel, but we don't guarantee it!

		var deferred = new Deferred<Int>();
		var future = deferred.future();

		#if (cpp || neko)
		var size = collection.size();
		if (size < MAX_ITERATIONS) {
			Collections.count(collection, func);
		} else {
			var tuple = threadPoolSize(size);

			var total = tuple._1();
			var length = tuple._2();

			var counter = new AtomicInteger();

			var actual = new AtomicInteger();
			var expected = total * (total + 1) / 2;

			var iterator = collection.iterator();
			for (index in 1...total + 1) {
				var items = gather(iterator, length);

				Thread.create(function () {
					var threadCollection = CollectionsUtil.toCollection(items);
					var threadCount = Collections.count(threadCollection, func);

					counter.add(threadCount);

					actual.add(index);
					
					if (actual.get() == expected) {
						deferred.resolve(counter.get());
					}
				});
			}
		}
		#else
		// Just reference the collections non-parallel one for unsupported targets.
		Collections.count(collection, func);
		#end

		return future;
	}

	public static function foldLeft<T>(collection : Collection<T>, value : T, func : Function2<T, T, T>) : Future<T> {
		// We aim to be parallel, but we don't guarantee it!

		var deferred = new Deferred<T>();
		var future = deferred.future();

		#if (cpp || neko)
		var size = collection.size();
		if (size < MAX_ITERATIONS) {
			deferred.resolve(Collections.foldLeft(collection, value, func));
		} else {
			var tuple = threadPoolSize(size);

			var total = tuple._1();
			var length = tuple._2();
			
			var results = new AtomicArray<T>();

			var actual = new AtomicInteger();
			var expected = total * (total + 1) / 2;

			// Go through and fold as much as possible

			var iterator = collection.iterator();
			for (index in 1...total + 1) {
				var items = gather(iterator, length);

				Thread.create(function () {
					var threadValue = index == 1 ? value : items.shift();

					var threadCollection = CollectionsUtil.toCollection(items);
					var threadResult = Collections.foldLeft(threadCollection, threadValue, func);

					actual.add(index);
					results.addAt(threadResult, index - 1);

					if (actual.get() == expected) {
						var threadArray = results.getAll();

						threadValue = threadArray.shift();
						threadCollection = CollectionsUtil.toCollection(threadArray);
						
						threadResult = Collections.foldLeft(threadCollection, threadValue, func);

						deferred.resolve(threadResult);
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

	public static function foreach<T>(collection : Collection<T>, func : Function1<T, Void>) : Void {
		// We aim to be parallel, but we don't guarantee it!

		#if (cpp || neko)
		var size = collection.size();
		if (size < MAX_ITERATIONS) {
			Collections.foreach(collection, func);
		} else {
			var tuple = threadPoolSize(size);

			var total = tuple._1();
			var length = tuple._2();

			var iterator = collection.iterator();
			for (index in 0...total) {
				var items = gather(iterator, length);

				Thread.create(function () {
					var threadCollection = CollectionsUtil.toCollection(items);
					Collections.foreach(threadCollection, func);
				});
			}
		}
		#else
		// Just reference the collections non-parallel one for unsupported targets.
		Collections.foreach(collection, func);
		#end
	}

	private inline static function threadPoolSize(size : Int) : Tuple2<Int, Int> {
		var total = Math.ceil(Math.log(size / 2));
		return tuple2(total, Math.ceil(size / total));
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

#if (cpp || neko)
private class AtomicInteger {

	private var _mutex : Mutex;

	private var _value : Int;

	public function new() {
		_mutex = new Mutex();
		_value = 0;
	}

	public function add(value : Int) : Void {
		_mutex.acquire();
		_value += value;
		_mutex.release();
	}

	public function get() : Int {
		_mutex.acquire();
		var result = _value;
		_mutex.release();
		return result;
	}
}

private class AtomicArray<T> {

	private var _mutex : Mutex;

	private var _value : Array<T>;

	public function new() {
		_mutex = new Mutex();
		_value = [];
	}

	public function add(value : T) : Void {
		_mutex.acquire();
		_value.push(value);
		_mutex.release();
	}

	public function addAt(value : T, index : Int) : Void {
		_mutex.acquire();
		_value[index] = value;
		_mutex.release();
	}

	public function addAll(value : Array<T>) : Void {
		_mutex.acquire();
		_value = _value.concat(value);
		_mutex.release();
	}

	public function get(index : Int) : T {
		_mutex.acquire();
		var result = _value[index];
		_mutex.release();
		return result;
	}

	public function getAll() : Array<T> {
		_mutex.acquire();
		var result = _value;
		_mutex.release();
		return result;	
	}
}
#end