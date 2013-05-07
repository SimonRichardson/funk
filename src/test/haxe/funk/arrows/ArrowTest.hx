package funk.arrows;

import funk.arrows.FutureArrow;
import funk.arrows.RepeatArrow;
import funk.types.Either;
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

        var func = function(x) return x < 10 ? Continue(x + 1) : Done(x);
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

    @Test
    public function when_creating_a_either_arrow_should_return_first_either() : Void {
        var actual = -1.0;
        var expected = 2.0;

        var func0 = function(x) return x + 1.0;
        var func1 = function(x) return x + .5;
        var arrow = func0.lift().either(func1.lift());

        arrow.apply(1.0).then(function(v) actual = v);

        actual.areEqual(expected);
    }

    @Test
    public function when_creating_arrow_with_left_choice_should_return_left_either() : Void {
        var actual = Left(-1);
        var expected = Left(2);

        var func = function(x) return x + 1;
        func.lift().left().apply(Left(1)).then(function(v) actual = v);

        actual.areEqual(expected);
    }

    @Test
    public function when_creating_arrow_with_left_choice_with_right_either_should_return_right_either_unmodified() : Void {
        var actual = Right(-1);
        var expected = Right(1);

        var func = function(x) return x + 1;
        func.lift().left().apply(Right(1)).then(function(v) actual = v);

        actual.areEqual(expected);
    }

    @Test
    public function when_creating_arrow_with_right_choice_should_return_right_either() : Void {
        var actual = Right(-1);
        var expected = Right(2);

        var func = function(x) return x + 1;
        func.lift().right().apply(Right(1)).then(function(v) actual = v);

        actual.areEqual(expected);
    }

    @Test
    public function when_creating_arrow_with_right_choice_with_left_either_should_return_left_either_unmodified() : Void {
        var actual = Left(-1);
        var expected = Left(1);

        var func = function(x) return x + 1;
        func.lift().right().apply(Left(1)).then(function(v) actual = v);

        actual.areEqual(expected);
    }
}
