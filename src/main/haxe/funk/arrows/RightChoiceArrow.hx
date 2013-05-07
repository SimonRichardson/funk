package funk.arrows;

import funk.arrows.ApplyArrow;
import funk.types.Either;
import funk.types.Function1;
import funk.types.Tuple2;

using funk.futures.Promise;

typedef ArrowRightChoice<A, B, C> = Arrow<Either<C, A>, Either<C, B>>;

abstract RightChoiceArrow<A, B, C>(ArrowRightChoice<A, B, C>) from ArrowRightChoice<A, B, C> to ArrowRightChoice<A, B, C> {

    inline public function new(arrow : Arrow<A, B>) {
        this = new Arrow(function(either : Either<C, A>, cont : Function1<Either<C, B>, Void>) {
            switch (either) {
                case Right(value): new ApplyArrow().arrow().withInput(tuple2(arrow, value), function(x) cont(Right(x)));
                case Left(value): cont(Left(value));
            }
        });
    }

    inline public function arrow() return this;

    inline public function apply(input : Either<C, A>) : Promise<Either<C, B>> return this.apply(input);
}
