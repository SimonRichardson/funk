package funk.types;

using Type;
using funk.types.Any;
using funk.types.Function2;
using funk.types.Tuple2;
using funk.types.Wildcard;
using massive.munit.Assert;

class Function2Test {

    @Test
    public function when_calling__1__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2) {
            called = value1;
        };
        a._1(true)(false);
        called.isTrue();
    }

    @Test
    public function when_calling__2__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2) {
            called = value2;
        };
        a._2(true)(false);
        called.isTrue();
    }

    @Test
    public function when_calling_compose__should_call_function_and_return_correct_response() : Void {
        var a = function(value) {
            return value;
        };

        var b = a.compose(function(value1, value2){
            return value1 || value2;
        })(false, true);

        b.isTrue();
    }

    @Test
    public function when_calling_map__should_call_function() : Void {
        var a = function(value1, value2) {
            return value1 || value2;
        };

        var b = a.map(function(value){
            return !!value;
        })(false, true);

        b.isTrue();
    }

    @Test
    public function when_calling_curry__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2) {
            called = true;
            return value1 || value2;
        };
        a.curry()(false)(true);
        called.isTrue();
    }

    @xTest
    public function when_calling_uncurry__should_call_function() : Void {
        var called = false;
        var a = function(value1) {
            return function(value2) {
                called = true;
                return value2;
            }
        }.uncurry()(1, 2);
        called.isTrue();
    }

    @Test
    public function when_calling_tuple__should_call_function() : Void {
        var a = function(value1, value2) {
            return value1 || value2;
        }.untuple()(tuple2(false, true));
        a.isTrue();
    }

    @Test
    public function when_calling_untuple__should_call_function() : Void {
        var a = function(t : Tuple2<Bool, Bool>) {
            return t;
        }.tuple()(false, true);
        a.areEqual(tuple2(false, true));
    }

    @Test
    public function when_carries_first_argument() : Void {
        var a = function(value1, value2) {
            return value1 + value2;
        }.carries(_, 1)(2);
        Assert.areEqual(a, 3);
    }

    @Test
    public function when_carries_second_argument() : Void {
        var a = function(value1, value2) {
            return value1 + value2;
        }.carries(1, _)(2);
        Assert.areEqual(a, 3);
    }

    @Test
    public function when_carries_both_arguments() : Void {
        var a = function(value1, value2) {
            return value1 + value2;
        }.carries(_, _)(1)(2);
        Assert.areEqual(a, 3);
    }

    @Test
    public function when_carries_no_arguments() : Void {
        var a = function(value1, value2) {
            return value1 + value2;
        }.carries(1, 2);
        Assert.areEqual(a, 3);
    }
}
