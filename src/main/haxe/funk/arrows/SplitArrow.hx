package funk.arrows;

import funk.arrows.PairArrow;
import funk.futures.Promise;
import funk.types.Function1;
import funk.types.Tuple2;

typedef ArrowSplit<A, B, C> = Arrow<A, Tuple2<B, C>>;

abstract SplitArrow<A, B, C>(ArrowSplit<A, B, C>) from ArrowSplit<A, B, C> to ArrowSplit<A, B, C> {

    inline public function new(left : Arrow<A, B>, right : Arrow<A, C>) {
        this = new Arrow(function(input : A, cont : Function1<Tuple2<B, C>, Void>) {
            new PairArrow(left, right).arrow().withInput(tuple2(input, input), cont);
        });
    }

    inline public function arrow() return this;

    inline public function apply(input : A) : Promise<Tuple2<B, C>> return this.apply(input);
}
