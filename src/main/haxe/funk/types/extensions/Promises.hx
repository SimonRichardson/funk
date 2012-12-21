package funk.types.extensions;

import funk.Funk;
import funk.types.Deferred;
import funk.types.Either;
import funk.types.Function0;
import funk.types.Function2;
import funk.types.Function5;
import funk.types.Option;
import funk.types.Predicate1;
import funk.types.Predicate5;
import funk.types.Promise;
import funk.types.Tuple2;

class Promises {

    public static function filter<T>(promise : Promise<T>, func : Predicate1<T>) : Promise<T> {
        var deferred = new Deferred<T>();
        var future = deferred.promise();

        promise.then(function (value : T) {
            if (func(value)) {
                deferred.resolve(value);
            } else {
                deferred.reject(Errors.Error());
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

    public static function flatten<T>(promise : Promise<Promise<T>>) : Promise<T> {
        var deferred = new Deferred<T>();
        var future = deferred.promise();

        promise.when(function (either : Either<Errors, T>) {
            switch (either) {
                case Left(e): deferred.reject(e);
                case Right(p):
                    p.when(function (either : Either<Errors, T>) {
                        switch (either) {
                            case Left(e): deferred.reject(e);
                            case Right(v): deferred.resolve(v);
                        }
                    });
                    p.progress(function (value : Float) {
                        deferred.progress(value);
                    });
            }
        });
        promise.progress(function (value : Float) {
            deferred.progress(value);
        });

        return future;
    }

    public static function map<T1, T2>(promise : Promise<T1>, func : Function1<T1, T2>) : Promise<T2> {
        var deferred = new Deferred<T2>();
        var future = deferred.promise();

        promise.when(function (either : Either<Errors, T>) {
            switch (either) {
                case Left(e): deferred.reject(e);
                case Right(value): deferred.resolve(func(value));
            }
        });
        promise.progress(function (value : Float) {
            deferred.progress(value);
        });

        return future;
    }

    public static function zip<T1, T2>(promise0 : Promise<T1>, promise1 : Promise<T2>) : Promise<Tuple2<T1, T2>> {
        return lift(function (a, b) {
            return tuple2(a, b);
        })(promise0, promise1);
    }

    public static function zipWith<T1, T2>( promise0 : Promise<T1>,
                                            promise1 : Promise<T2>,
                                            func : Function2<T1, T2, R>
                                            ) : Promise<Tuple2<T1, T2>> {
        return lift(func)(promise0, promise1);
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
            a.when(function (either : Either<Errors, T1>) {
                deferred.progress(progress + 0.5);

                switch (either) {
                    case Left(e): deferred.reject(e);
                    case Right(v): value0 = Some(v);
                }

                check();
            });
            b.when(function (either : Either<Errors, T2>) {
                deferred.progress(progress + 0.5);

                switch (either) {
                    case Left(e): deferred.reject(e);
                    case Right(v): value1 = Some(v);
                }

                check();
            });

            return promise;
        }
    }

}
