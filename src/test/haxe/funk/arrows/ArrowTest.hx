package funk.arrows;

import funk.arrows.FutureArrow;
import funk.arrows.RepeatArrow;
import funk.types.Option;

using funk.arrows.Arrow;
using funk.futures.Promise;
using massive.munit.Assert;

class ArrowTest {

    private var _arrow : Arrow<Dynamic, Dynamic>;

    @Before
    public function setup() : Void {
        _arrow = Arrow.unit();
    }

    @Test
    public function when_creating_a_arrow_and_lifting_then_arrow_value_should_be_11() : Void {
        var actual = -1;
        var expected = 11;

        var func = function(x) return x + 1;
        var arrow = _arrow.then(func.lift());

        arrow.apply(10).then(function(v) actual = v);

        actual.areEqual(expected);
    }

    @Test
    public function when_creating_a_arrow_and_lifting_whilst_repeating_should_then_arrow_value_should_be_10() : Void {
        var actual = -1;
        var expected = 10;

        var func = function(x) return x < 10 ? Cont(x + 1) : Done(x);
        var arrow = _arrow.then(func.lift().repeat());

        arrow.apply(0).then(function(v) actual = v);

        actual.areEqual(expected);
    }

    @Test
    public function when_creating_a_future_arrow_and_passing_arrow_should_then_be_2() : Void {
        var actual = -1;
        var expected = 2;

        var func = function(x) return x + 1;
        var arrow = Arrow.future().then(func.lift());

        arrow.apply(PromiseTypes.pure(1)).then(function(v) actual = v);

        actual.areEqual(expected);
    }

    @Test
    public function when_creating_a_arrowOf_a_function_should_then_be_2() : Void {
        var actual = -1;
        var expected = 2;

        var func = function(x) return PromiseTypes.pure(x + 1);
        var arrow = _arrow.then(func.arrowOf());

        arrow.apply(1).then(function(v) actual = v);

        actual.areEqual(expected);
    }

    @Test
    public function when_creating_a_option_arrow_passing_some_1_should_then_be_some_2() : Void {
        var actual = None;
        var expected = Some(2);

        var func = function(x) return x + 1;
        var arrow = _arrow.then(func.lift().option());

        arrow.apply(Some(1)).then(function(v) actual = v);

        actual.areEqual(expected);
    }

    @Test
    public function when_creating_a_option_arrow_passing_none_should_then_be_none() : Void {
        var actual = Some(1);
        var expected = None;

        var func = function(x) return x + 1;
        var arrow = _arrow.then(func.lift().option());

        arrow.apply(None).then(function(v) actual = v);

        actual.areEqual(expected);
    }
}
