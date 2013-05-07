package funk.arrows;

import funk.arrows.ApplyArrow;
import funk.types.Either;
import funk.types.Function1;
import funk.types.Tuple2;

using funk.futures.Promise;

typedef ArrowLeftChoice<A, B, C> = Arrow<Either<A, C>, Either<B, C>>;

abstract LeftChoiceArrow<A, B, C>(ArrowLeftChoice<A, B, C>) from ArrowLeftChoice<A, B, C> to ArrowLeftChoice<A, B, C> {

    inline public function new(arrow : Arrow<A, B>) {
        this = new Arrow(function(either : Either<A, C>, cont : Function1<Either<B, C>, Void>) {
            switch (either) {
                case Left(value): new ApplyArrow().arrow().withInput(tuple2(arrow, value), function(x) cont(Left(x)));
                case Right(value): cont(Right(value));
            }
        });
    }

    inline public function arrow() return this;

    inline public function apply(input : Either<A, C>) : Promise<Either<B, C>> return this.apply(input);
}
