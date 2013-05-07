package funk.arrows;

import funk.Funk;
import funk.futures.Deferred;
import funk.types.Attempt;
import funk.types.Either;
import funk.types.Function1;
import funk.types.Option;

using funk.ds.Collection;
using funk.futures.Promise;

abstract EitherArrow<I, O>(Arrow<I, O>) from Arrow<I, O> to Arrow<I, O> {

    inline public function new(a : Arrow<I, O>, b : Arrow<I, O>) {
        this = new Arrow(function(input : I, cont : Function1<O, Void>) {

            var deferred = new Deferred();
            // TODO (Simon) : We could work out if a Promise has failed.
            deferred.promise().then(function (v) cont(v));

            var handler : Function1<Attempt<EitherType<O, O>>, Void> = function(attempt : Attempt<EitherType<O, O>>) : Void {
                switch (deferred.states().last()) {
                    case Some(Resolved(_)): // Already been resolved, too late!
                    case Some(Rejected(_)): // Already been rejected, too late!
                    case _: 
                        switch(attempt) {
                            case Success(either):
                                deferred.resolve(switch(either) {
                                    case Left(value): value;
                                    case Right(value): value;
                                });
                            case Failure(error): deferred.reject(error); 
                        }
                }
            };

            // In theory (a) could always be resolved first if a has already been resolved.
            a.apply(input).map(function(x) return Left(x)).when(handler);
            b.apply(input).map(function(x) return Right(x)).when(handler);
        });
    }

    inline public function arrow() return this;

    inline public function apply(input : I) : Promise<O> return this.apply(input);
}
