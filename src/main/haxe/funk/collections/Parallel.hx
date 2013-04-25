package funk.collections;

import funk.Funk;
import funk.futures.Deferred;
import funk.futures.Promise;
import funk.types.Function1;
import funk.types.Function2;
import funk.types.Function3;
import funk.types.Predicate1;
import funk.types.Predicate2;
import funk.types.Any;

using funk.types.Option;
using funk.collections.Collection;
using funk.types.Tuple2;

#if neko
import neko.vm.Mutex;
import neko.vm.Thread;
#elseif cpp
import cpp.vm.Mutex;
import cpp.vm.Thread;
#end

class Parallels {

    private static inline var AMOUNT : Int = 9999;

    public static function count<T>(collection : Collection<T>, func : Predicate1<T>) : Promise<Int> {
        var deferred = new Deferred<Int>();
        var promise = deferred.promise();

        #if (cpp || neko)
        var counter = new AtomicInteger();

        var iterator = collection.iterator();
        while(iterator.hasNext()) {
            Thread.create(function (items : Array<T>, isEmpty : Bool) {
                return function () {
                    var threadCollection = CollectionUtil.toCollection(items);
                    var threadCount = CollectionTypes.count(threadCollection, func);

                    counter.add(threadCount);

                    if (isEmpty) {
                        deferred.resolve(counter.get());
                    }
                };
            }(gather(iterator, AMOUNT), !iterator.hasNext()));
        }
        #else
        // Just reference the collections non-parallel one for unsupported targets.
        deferred.resolve(CollectionTypes.count(collection, func));
        #end

        return promise;
    }

    public static function filter<T>(collection : Collection<T>, func : Predicate1<T>) : Promise<Collection<T>> {
        var deferred = new Deferred<Collection<T>>();
        var promise = deferred.promise();

        #if (cpp || neko)
        var results = new AtomicArray<T>();

        var iterator = collection.iterator();
        while(iterator.hasNext()) {
            Thread.create(function (items : Array<T>, isEmpty : Bool) {
                return function () {
                    var threadResult = [];

                    for (item in items) {
                        if (func(item)) {
                            threadResult.push(item);
                        }
                    }

                    results.addAll(threadResult);

                    if (isEmpty) {
                        var threadArray = results.getAll();
                        var threadCollection = CollectionUtil.toCollection(threadArray);

                        deferred.resolve(threadCollection);
                    }
                };
            }(gather(iterator, AMOUNT), !iterator.hasNext()));
        }
        #else
        // Just reference the collections non-parallel one for unsupported targets.
        deferred.resolve(CollectionTypes.filter(collection, func));
        #end

        return promise;
    }

    public static function filterNot<T>(collection : Collection<T>, func : Predicate1<T>) : Promise<Collection<T>> {
        var deferred = new Deferred<Collection<T>>();
        var promise = deferred.promise();

        #if (cpp || neko)
        var results = new AtomicArray<T>();

        var iterator = collection.iterator();
        while(iterator.hasNext()) {
            Thread.create(function (items : Array<T>, isEmpty : Bool) {
                return function () {
                    var threadResult = [];

                    for (item in items) {
                        if (!func(item)) {
                            threadResult.push(item);
                        }
                    }

                    results.addAll(threadResult);

                    if (isEmpty) {
                        var threadArray = results.getAll();
                        var threadCollection = CollectionUtil.toCollection(threadArray);

                        deferred.resolve(threadCollection);
                    }
                };
            }(gather(iterator, AMOUNT), !iterator.hasNext()));
        }
        #else
        // Just reference the collections non-parallel one for unsupported targets.
        deferred.resolve(CollectionTypes.filterNot(collection, func));
        #end

        return promise;
    }

    public static function foldLeft<T>( collection : Collection<T>,
                                        value : T,
                                        func : Function2<T, T, T>
                                        ) : Promise<Option<T>> {
        var deferred = new Deferred<Option<T>>();
        var promise = deferred.promise();

        #if (cpp || neko)
        var results = new AtomicArray<T>();
        var index = 0;
        var iterator = collection.iterator();
        while(iterator.hasNext()) {
            Thread.create(function (items : Array<T>, index : Int, isEmpty : Bool) {
                return function () {
                    var threadValue = index == 0 ? value : items.shift();

                    var threadCollection = CollectionUtil.toCollection(items);
                    var threadResult = CollectionTypes.foldLeft(threadCollection, threadValue, func);

                    results.addAt(threadResult.get(), index);

                    if (isEmpty) {
                        var threadArray = results.getAll();

                        threadValue = threadArray.shift();
                        threadCollection = CollectionUtil.toCollection(threadArray);

                        threadResult = CollectionTypes.foldLeft(threadCollection, threadValue, func);

                        deferred.resolve(threadResult);
                    }
                };
            }(gather(iterator, AMOUNT), index++, !iterator.hasNext()));
        }
        #else
        // Just reference the collections non-parallel one for unsupported targets.
        deferred.resolve(CollectionTypes.foldLeft(collection, value, func));
        #end

        return promise;
    }

    public static function foldRight<T>(    collection : Collection<T>,
                                            value : T,
                                            func : Function2<T, T, T>
                                            ) : Promise<Option<T>> {
        var deferred = new Deferred<Option<T>>();
        var promise = deferred.promise();

        #if (cpp || neko)
        var results = new AtomicArray<T>();
        var index = 0;
        var iterator = collection.iterator();
        while(iterator.hasNext()) {
            Thread.create(function (items : Array<T>, index : Int, isEmpty : Bool) {
                return function () {
                    var threadValue = index == 0 ? value : items.shift();

                    var threadCollection = CollectionUtil.toCollection(items);
                    var threadResult = CollectionTypes.foldRight(threadCollection, threadValue, func);

                    results.addAt(threadResult.get(), index);

                    if (isEmpty) {
                        var threadArray = results.getAll();

                        threadValue = threadArray.shift();
                        threadCollection = CollectionUtil.toCollection(threadArray);

                        threadResult = CollectionTypes.foldRight(threadCollection, threadValue, func);

                        deferred.resolve(threadResult);
                    }
                };
            }(gather(iterator, AMOUNT), index++, !iterator.hasNext()));
        }
        #else
        // Just reference the collections non-parallel one for unsupported targets.
        deferred.resolve(CollectionTypes.foldRight(collection, value, func));
        #end

        return promise;
    }

    public static function foreach<T>(collection : Collection<T>, func : Function1<T, Void>) : Void {
        #if (cpp || neko)
        var iterator = collection.iterator();
        while(iterator.hasNext()) {
            Thread.create(function (items : Array<T>) {
                return function () {
                    var threadCollection = CollectionUtil.toCollection(items);
                    CollectionTypes.foreach(threadCollection, func);
                };
            }(gather(iterator, AMOUNT)));
        }
        #else
        // Just reference the collections non-parallel one for unsupported targets.
        CollectionTypes.foreach(collection, func);
        #end
    }

    public static function map<T, R>(collection : Collection<T>, func : Function1<T, R>) : Promise<Collection<R>> {
        var deferred = new Deferred<Collection<R>>();
        var promise = deferred.promise();

        #if (cpp || neko)
        var results = new AtomicArray<R>();

        var iterator = collection.iterator();
        while(iterator.hasNext()) {
            Thread.create(function (items : Array<T>, isEmpty : Bool) {
                return function () {
                    var threadResult = [];

                    for (item in items) {
                        threadResult.push(func(item));
                    }

                    results.addAll(threadResult);

                    if (isEmpty) {
                        var threadArray = results.getAll();
                        var threadCollection = CollectionUtil.toCollection(threadArray);

                        deferred.resolve(threadCollection);
                    }
                }
            }(gather(iterator, AMOUNT), !iterator.hasNext()));
        }
        #else
        // Just reference the collections non-parallel one for unsupported targets.
        deferred.resolve(CollectionTypes.map(collection, func));
        #end

        return promise;
    }

    public static function reduceLeft<T>(collection : Collection<T>, func : Function2<T, T, T>) : Promise<Option<T>> {
        var deferred = new Deferred<Option<T>>();
        var promise = deferred.promise();

        #if (cpp || neko)
        var results = new AtomicArray<T>();
        var index = 0;
        var iterator = collection.iterator();
        while(iterator.hasNext()) {
            Thread.create(function (items : Array<T>, index : Int, isEmpty : Bool) {
                return function () {
                    var threadCollection = CollectionUtil.toCollection(items);
                    var threadResult = CollectionTypes.reduceLeft(threadCollection, func);

                    results.addAt(threadResult.get(), index);

                    if (isEmpty) {
                        var threadArray = results.getAll();

                        threadCollection = CollectionUtil.toCollection(threadArray);

                        threadResult = CollectionTypes.reduceLeft(threadCollection, func);

                        deferred.resolve(threadResult);
                    }
                }
            }(gather(iterator, AMOUNT), index++, !iterator.hasNext()));
        }
        #else
        // Just reference the collections non-parallel one for unsupported targets.
        deferred.resolve(CollectionTypes.reduceLeft(collection, func));
        #end

        return promise;
    }

    public static function reduceRight<T>(collection : Collection<T>, func : Function2<T, T, T>) : Promise<Option<T>> {
        var deferred = new Deferred<Option<T>>();
        var promise = deferred.promise();

        #if (cpp || neko)
        var results = new AtomicArray<T>();
        var index = 0;
        var iterator = collection.iterator();
        while(iterator.hasNext()) {
            Thread.create(function(items : Array<T>, index : Int, isEmpty : Bool) {
                return function () {
                    var threadCollection = CollectionUtil.toCollection(items);
                    var threadResult = CollectionTypes.reduceRight(threadCollection, func);

                    results.addAt(threadResult.get(), index);

                    if (isEmpty) {
                        var threadArray = results.getAll();

                        threadCollection = CollectionUtil.toCollection(threadArray);

                        threadResult = CollectionTypes.reduceRight(threadCollection, func);

                        deferred.resolve(threadResult);
                    }
                }
            }(gather(iterator, AMOUNT), index++, !iterator.hasNext()));
        }
        #else
        // Just reference the collections non-parallel one for unsupported targets.
        deferred.resolve(CollectionTypes.reduceRight(collection, func));
        #end

        return promise;
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
