package funk.types;

using Type;
using funk.types.Any;
using funk.types.Function3;
using funk.types.Tuple3;
using funk.types.Wildcard;
using massive.munit.Assert;

class Function3Test {

    @Test
    public function when_calling__1__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3) {
            called = value1;
        };
        a._1(true)(false, false);
        called.isTrue();
    }

    @Test
    public function when_calling__2__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3) {
            called = value2;
        };
        a._2(true)(false, false);
        called.isTrue();
    }

    @Test
    public function when_calling__3__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3) {
            called = value3;
        };
        a._3(true)(false, false);
        called.isTrue();
    }

    @Test
    public function when_calling_compose__should_call_function_and_return_correct_response() : Void {
        var a = function(value) {
            return value;
        };

        var b = a.compose(function(value1, value2, value3){
            return value1 || value2 || value3;
        })(false, true, false);

        b.isTrue();
    }

    @Test
    public function when_calling_map__should_call_function() : Void {
        var a = function(value1, value2, value3) {
            return value1 || value2 || value3;
        };

        var b = a.map(function(value){
            return !!value;
        })(false, true, false);

        b.isTrue();
    }

    @Test
    public function when_calling_curry__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3) {
            called = true;
            return value1 || value2 || value3;
        };
        a.curry()(false)(true)(false);
        called.isTrue();
    }

    @xTest
    public function when_calling_uncurry__should_call_function() : Void {
        var called = false;
        var a = function(value1) {
            return function(value2) {
                return function(value3) {
                    called = true;
                    return value3;
                }
            }
        }.uncurry()(1, 2, 3);
        called.isTrue();
    }

    @Test
    public function when_calling_tuple__should_call_function() : Void {
        var a = function(value1, value2, value3) {
            return value1 || value2 || value3;
        }.untuple()(tuple3(false, true, false));
        a.isTrue();
    }

    @Test
    public function when_calling_untuple__should_call_function() : Void {
        var a = function(t : Tuple3<Bool, Bool, Bool>) {
            return t;
        }.tuple()(false, true, false);
        a.areEqual(tuple3(false, true, false));
    }


    @Test
    public function when_carries_first_argument() : Void {
        var a = function(value1, value2, value3) {
            return value1 + value2 + value3;
        }.carries(_, 2, 3)(1);
        Assert.areEqual(a, 6);
    }

    @Test
    public function when_carries_second_argument() : Void {
        var a = function(value1, value2, value3) {
            return value1 + value2 + value3;
        }.carries(1, _, 3)(2);
        Assert.areEqual(a, 6);
    }

    @Test
    public function when_carries_third_argument() : Void {
        var a = function(value1, value2, value3) {
            return value1 + value2 + value3;
        }.carries(1, 2, _)(3);
        Assert.areEqual(a, 6);
    }

    @Test
    public function when_carries_first_and_second_arguments() : Void {
        var a = function(value1, value2, value3) {
            return value1 + value2 + value3;
        }.carries(_, _, 3)(1)(2);
        Assert.areEqual(a, 6);
    }

    @Test
    public function when_carries_first_and_third_arguments() : Void {
        var a = function(value1, value2, value3) {
            return value1 + value2 + value3;
        }.carries(_, 2, _)(1)(3);
        Assert.areEqual(a, 6);
    }

    @Test
    public function when_carries_second_and_third_arguments() : Void {
        var a = function(value1, value2, value3) {
            return value1 + value2 + value3;
        }.carries(1, _, _)(2)(3);
        Assert.areEqual(a, 6);
    }

    @Test
    public function when_carries_all_arguments() : Void {
        var a = function(value1, value2, value3) {
            return value1 + value2 + value3;
        }.carries(_, _, _)(1)(2)(3);
        Assert.areEqual(a, 6);
    }

    @Test
    public function when_carries_no_arguments() : Void {
        var a = function(value1, value2, value3) {
            return value1 + value2 + value3;
        }.carries(1, 2, 3);
        Assert.areEqual(a, 6);
    }

    @Test
    public function when_calling_lazy__should_return_value() : Void {
        var instance = Math.random();
        function(a, b, c) {
            return instance + a + b + c;
        }.lazy(1, 2, 3)().areEqual(instance + 1 + 2 + 3);
    }

    @Test
    public function when_calling_lazy_twice__should_return_same_value() : Void {
        var instance = Math.random();
        var lax = function(a, b, c) {
            return instance + a + b + c;
        };
        lax.lazy(1, 2, 3)();
        lax.lazy(1, 2, 3)().areEqual(instance + 1 + 2 + 3);
    }

    @Test
    public function when_calling_lazy_twice__should_return_same_instance() : Void {
        var lax = function(a, b, c) {
            return Math.random();
        }.lazy(1, 2, 3);
        lax().areEqual(lax());
    }

    @Test
    public function when_calling_lazy_twice__should_be_called_once() : Void {
        var amount = 0;
        var lax = function(a, b, c) {
            amount++;
            return {};
        }.lazy(1, 2, 3);
        lax();
        lax();
        amount.areEqual(1);
    }
}
