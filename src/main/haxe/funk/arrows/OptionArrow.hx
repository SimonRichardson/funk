package funk.arrows;

import funk.arrows.Arrow;
import funk.types.Function1;

using funk.types.Option;
using funk.types.Tuple2;
using funk.futures.Promise;

typedef ArrowOption<I, O> = Arrow<Option<I>, Option<O>>;

abstract OptionArrow<I, O>(ArrowOption<I, O>) from ArrowOption<I, O> to ArrowOption<I, O> {

    inline public function new(arrow : Arrow<I, O>) {
        this = new Arrow(function(option : Option<I>, cont : Function1<Option<O>, Void>) {
            switch(option) {
                case Some(value): ArrowTypes.apply().withInput(tuple2(arrow, value), function(x) return cont(Some(x)));
                case _: cont(None);
            }
        });
    }

    inline public function arrow() return this;

    inline public function apply(input : Option<I>) : Promise<Option<O>> return this.apply(input);

    public static function unit<I>() : OptionArrow<I, I> return new OptionArrow(Arrow.unit());

    public static function pure<I, O>(arrow : Arrow<I, O>) : OptionArrow<I, O> return new OptionArrow(arrow);
}
