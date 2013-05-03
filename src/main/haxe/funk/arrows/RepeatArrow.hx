package funk.arrows;

using funk.types.Function1;

enum FreeM<A, B> {
    Cont(value : A);
    Done(value : B);
}

abstract RepeatArrow<I, O>(Arrow<I, O>) from Arrow<I, O> to Arrow<I, O> {

    inline public function new(arrow : Arrow<I, FreeM<I, O>>) {
        this = new Arrow(function(input : I, cont : Function1<O, Void>) : Void {
            function withResult(result : FreeM<I, O>) {
                switch(result) {
                    case Cont(v): arrow.withInput(v, withResult.trampoline());
                    case Done(v): cont(v);
                }
            }
            arrow.withInput(input, withResult);
        });
    }
}
