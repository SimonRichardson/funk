package funk.arrows;

using funk.types.Function1;
using funk.futures.Promise;

enum Repetition<A, B> {
    Continue(value : A);
    Done(value : B);
}

abstract RepeatArrow<I, O>(Arrow<I, O>) from Arrow<I, O> to Arrow<I, O> {

    inline public function new(arrow : Arrow<I, Repetition<I, O>>) {
        this = new Arrow(function(input : I, cont : Function1<O, Void>) : Void {
            function withResult(result : Repetition<I, O>) {
                switch(result) {
                    case Continue(v): arrow.withInput(v, withResult.trampoline());
                    case Done(v): cont(v);
                }
            }
            arrow.withInput(input, withResult);
        });
    }

    inline public function arrow() return this;

    inline public function apply(input : I) : Promise<O> return this.apply(input);
}
