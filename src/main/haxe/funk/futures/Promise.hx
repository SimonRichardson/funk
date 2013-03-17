package funk.futures;

import funk.Funk;

using funk.collections.immutable.List;
using funk.futures.Deferred;
using funk.types.Attempt;
using funk.types.Function1;
using funk.types.Function2;
using funk.types.Predicate1;
using funk.types.Option;
using funk.types.Tuple2;

typedef Promise<T> = {

    function then(func : Function1<T, Void>) : Promise<T>;

    function but(func : Function1<Errors, Void>) : Promise<T>;

    function when(func : Function1<Attempt<T>, Void>) : Promise<T>;

    function progress(func : Function1<Float, Void>) : Promise<T>;
}

class PromiseTypes {

    public static function awaitAll<T>(list : List<Promise<T>>) : Promise<List<T>> {
        var deferred = new Deferred();
        var promise = deferred.promise();

        var result : List<T> = Nil;

        var index = 0;
        var size = list.size();
        while (list.nonEmpty()){
            var future = list.head();

            future.then(function (value : T) {
                result = result.prepend(value);

                if (result.size() == size) {
                    deferred.resolve(result);
                }
            });
            future.but(function (e : Errors) {
                deferred.reject(e);
            });
            future.progress(function (value : Float) {
                deferred.progress((index / size) * value);
            });

            list = list.tail();
            index++;
        }

        return promise;
    }

    public static function empty<T>() : Promise<T> {
        return new EmptyPromise();
    }

    public static function _but<T1, T2>(promise : Promise<T1>, func : Function1<T1, T2>) : Promise<T2> {
        return map(promise, func);
    }

    public static function _then<T1, T2>(promise : Promise<T1>, func : Function1<T1, T2>) : Promise<T2> {
        return map(promise, func);
    }

    public static function _when<T1, T2>(promise : Promise<T1>, func : Function1<T1, T2>) : Promise<T2> {
        return map(promise, func);
    }

    public static function reject<T>(value : String) : Promise<T> {
        var deferred = new Deferred();
        var promise = deferred.promise();
        deferred.reject(ActorError(value));
        return promise;
    }

    public static function dispatch<T>(value : T) : Promise<T> {
        var deferred = new Deferred();
        var promise = deferred.promise();

        deferred.resolve(value);

        return promise;
    }

    public static function filter<T>(promise : Promise<T>, func : Predicate1<T>) : Promise<T> {
        var deferred = new Deferred<T>();
        var future = deferred.promise();

        promise.then(function (value : T) {
            if (func(value)) {
                deferred.resolve(value);
            } else {
                deferred.reject(Error(''));
            }
        });
        promise.but(function (e : Errors) {
            deferred.reject(e);
        });
        promise.progress(function (value : Float) {
            deferred.progress(value);
        });

        return future;
    }

    public static function flatMap<T1, T2>(promise : Promise<T1>, func : Function1<T1, Promise<T2>>) : Promise<T2> {
        var deferred = new Deferred<T2>();
        var future = deferred.promise();

        promise.when(function (attempt : Attempt<T1>) {
            switch (attempt) {
                case Failure(e): deferred.reject(e);
                case Success(value):

                    var p = func(value);
                    p.when(function (attempt : Attempt<T2>) {
                        switch (attempt) {
                            case Failure(e): deferred.reject(e);
                            case Success(v): deferred.resolve(v);
                            case _: deferred.reject(IllegalOperationError());
                        }
                    });

                    p.progress(function (value : Float) {
                        deferred.progress(0.5 + value * 0.5);
                    });

                case _: deferred.reject(IllegalOperationError());
            }
        });
        promise.progress(function (value : Float) {
            deferred.progress(value * 0.5);
        });

        return future;
    }

    public static function flatten<T>(promise : Promise<Promise<T>>) : Promise<T> {
        var deferred = new Deferred<T>();
        var future = deferred.promise();

        promise.when(function (attempt : Attempt<Promise<T>>) {
            switch (attempt) {
                case Failure(e): deferred.reject(e);
                case Success(p): pipe(p, deferred);
                case _: deferred.reject(IllegalOperationError());
            }
        });

        promise.progress(function (value : Float) {
            deferred.progress(value);
        });

        return future;
    }

    public static function lift<T1, T2, R>( func : Function2<T1, T2, R>
                                            ) : Function2<Promise<T1>, Promise<T2>, Promise<R>> {
        return function (a : Promise<T1>, b : Promise<T2>) : Promise<R> {
            var deferred = new Deferred<R>();
            var promise = deferred.promise();

            var value0 = None;
            var value1 = None;

            function check() {
                if (value0.isDefined() && value1.isDefined()) {
                    deferred.resolve(func(value0.get(), value1.get()));
                }
            };

            var progress = 0.0;

            a.when(function (attempt : Attempt<T1>) {
                deferred.progress(progress + 0.5);

                switch (attempt) {
                    case Failure(e): deferred.reject(e);
                    case Success(v): value0 = Some(v);
                    case _: deferred.reject(IllegalOperationError());
                }

                check();
            });

            b.when(function (attempt : Attempt<T2>) {
                deferred.progress(progress + 0.5);

                switch (attempt) {
                    case Failure(e): deferred.reject(e);
                    case Success(v): value1 = Some(v);
                    case _: deferred.reject(IllegalOperationError());
                }

                check();
            });

            return promise;
        };
    }

    public static function pipe<T>(promise : Promise<T>, deferred : Deferred<T>) : Promise<T> {
        promise.progress(function(value) {
            deferred.progress(value);
        });

        promise.when(function(attempt) {
            switch (attempt) {
                case Failure(error): deferred.reject(error);
                case Success(value): deferred.resolve(value);
                case _: deferred.reject(IllegalOperationError());
            }
        });

        return promise;
    }

    public static function map<T1, T2>(promise : Promise<T1>, func : Function1<T1, T2>) : Promise<T2> {
        var deferred = new Deferred<T2>();
        var future = deferred.promise();

        promise.when(function (attempt : Attempt<T1>) {
            switch (attempt) {
                case Failure(error): deferred.reject(error);
                case Success(value): deferred.resolve(func(value));
                case _: deferred.reject(IllegalOperationError());
            }
        });

        promise.progress(function (value : Float) {
            deferred.progress(value);
        });

        return future;
    }

    public static function zip<T1, T2>(promise0 : Promise<T1>, promise1 : Promise<T2>) : Promise<Tuple2<T1, T2>> {
        return lift(function (a, b) {
            var tuple : Tuple2<T1, T2> = tuple2(a, b);
            return tuple;
        })(promise0, promise1);
    }

    public static function zipWith<T1, T2, R>(  promise0 : Promise<T1>,
                                                promise1 : Promise<T2>,
                                                func : Function2<T1, T2, R>
                                                ) : Promise<R> {
        return lift(func)(promise0, promise1);
    }
}
