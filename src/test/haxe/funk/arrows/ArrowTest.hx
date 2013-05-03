package funk.arrows;

import funk.arrows.RepeatArrow;

using funk.arrows.Arrow;
using funk.futures.Promise;

class ArrowTest {

    private var _arrow : Arrow<Dynamic, Dynamic>;

    @Before
    public function setup() : Void {
        _arrow = Arrow.unit();
    }

    @Test
    public function when() : Void {
        var func = function(x) return x + 1;
        var arrow = _arrow.then(func.lift());

        arrow.apply(10).then(function(v) trace(v));
    }

    @Test
    public function when2() : Void {
        var func = function(x) return x < 10 ? Cont(x + 1) : Done(x);
        var arrow = _arrow.then(func.lift().repeat());

        arrow.apply(0).then(function(v) trace(v));
    }
}
