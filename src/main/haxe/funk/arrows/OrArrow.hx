package funk.arrows;

import funk.futures.Promise;
import funk.types.Either;
import funk.types.Function1;

typedef ArrowOr<L, R, P> = Arrow<Either<L, R>, P>;

abstract OrArrow<L, R, P>(ArrowOr<L, R, P>) from ArrowOr<L, R, P> to ArrowOr<L, R, P> {

    inline public function new(left : Arrow<L, P>, right : Arrow<R, P>) {
        this = new Arrow(function(either : Either<L, R>, cont : Function1<P, Void>) {
            switch(either) {
                case Left(value): left.withInput(value, cont);
                case Right(value): right.withInput(value, cont);
            }
        });
    }

    inline public function arrow() return this;

    inline public function apply(input : Either<L, R>) : Promise<P> return this.apply(input);
}
