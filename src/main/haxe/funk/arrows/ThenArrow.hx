package funk.arrows;

import funk.types.Function1;

abstract ThenArrow<I, O, NO>(Arrow<I, NO>) from Arrow<I, NO> to Arrow<I, NO> {

    inline public function new(a : Arrow<I, O>, b : Arrow<O, NO>) {
        this = new Arrow(function(input : I, cont : Function1<NO, Void>) : Void {
            a.withInput(input, function(reta : O) b.withInput(reta, cont));
        });
    }
}
