package funk.arrows;

using funk.futures.Promise;
using funk.types.Function1;

typedef ArrowFuture<O> = Arrow<Promise<O>, O>;

abstract FutureArrow<O>(ArrowFuture<O>) from ArrowFuture<O> to ArrowFuture<O> {

    inline public function new() {
        this = new Arrow(function(input : Promise<O>, cont : Function1<O, Void>) : Void input.then(cont));
    }

    inline public function arrow() return this;

    inline public function apply(input : Promise<O>) : Promise<O> return this.apply(input);
}
