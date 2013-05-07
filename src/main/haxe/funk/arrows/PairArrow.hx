package funk.arrows;

import funk.futures.Promise;
import funk.types.Any;
import funk.types.Function1;

using funk.types.Option;
using funk.types.Tuple2;

typedef ArrowPair<A, B, C, D> = Arrow<Tuple2<A, C>, Tuple2<B, D>>;

abstract PairArrow<A, B, C, D>(ArrowPair<A, B, C, D>) from ArrowPair<A, B, C, D> to ArrowPair<A, B, C, D> {

    inline public function new(left : Arrow<A, B>, right : Arrow<C, D>) {
        this = new Arrow(function(tuple : Tuple2<A, C>, cont : Function1<Tuple2<B, D>, Void>) {
            var leftOption : Option<B> = null;
            var rightOption : Option<D> = null;

            function check() {
                if (AnyTypes.toBool(leftOption) && AnyTypes.toBool(rightOption)) {
                    cont(tuple2(    leftOption.getOrElse(function() return null),
                                    rightOption.getOrElse(function() return null)
                                    ));
                }
            }

            left.withInput(tuple._1(), function(value : B) {
                leftOption = OptionTypes.toOption(value);
                check();
            });
            right.withInput(tuple._2(), function(value : D) {
                rightOption = OptionTypes.toOption(value);
                check();
            });
        });
    }

    inline public function arrow() return this;

    inline public function apply(input : Tuple2<A, C>) : Promise<Tuple2<B, D>> return this.apply(input);
}
