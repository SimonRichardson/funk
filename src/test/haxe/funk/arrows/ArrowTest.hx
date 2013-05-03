package funk.arrows;

import funk.arrows.RepeatArrow;

using funk.arrows.Arrow;
using funk.futures.Promise;

class ArrowTest {

    @Test
    public function when() : Void {
        var a = Arrow.unit();
        var b = function(x) return x + 1;
        var c = a.then(b.lift());

        c.apply(10).then(function(v) trace(v));
    }

    @Test
    public function when2() : Void {
        var a = Arrow.unit();
        var b = function(x) return x < 10 ? Cont(x + 1) : Done(x);
        var c = a.then(b.lift().repeat());

        c.apply(0).then(function(v) trace(v));
    }
}
