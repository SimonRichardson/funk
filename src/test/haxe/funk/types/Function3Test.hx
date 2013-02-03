package funk.types;

import Type;
import funk.types.Function0;
import funk.types.Tuple3;
import funk.types.extensions.Functions3;
import funk.types.extensions.Tuples3;
import massive.munit.Assert;

using Type;
using funk.types.extensions.Functions3;
using funk.types.extensions.Tuples3;
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
        /**
         * FIXME (Simon) : This is broken in the latest release of haxe.
        var called = false;
        var a = function(value) {
            return function () {
                called = true;
                return value;
            }
        }.uncurry();
        called.isTrue();
        */
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
    public function when_calling_wait__should_not_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3) {
            called = true;
        };

        var aa = a.wait();
        called.isFalse();
    }

    @Test
    public function when_calling_wait_then_yield__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3) {
            called = true;
        };

        var aa = a.wait();
        aa.yield(1, 2, 3);

        called.isTrue();
    }

    @Test
    public function when_chaining_wait_then_yield__should_call_second_function() : Void {
        var called0 = false;
        var called1 = false;

        var a = function(value1, value2, value3) {
            called0 = true;
        };
        var b = function(value1, value2, value3) {
            called1 = true;
        };

        var aa = a.wait();
        var bb = b.wait(aa);

        bb.yield(1, 2, 3);

        called1.isTrue();
    }

    @Test
    public function when_chaining_wait_then_yield__should_call_first_function() : Void {
        var called0 = false;
        var called1 = false;

        var a = function(value1, value2, value3) {
            called0 = true;
        };
        var b = function(value1, value2, value3) {
            called1 = true;
        };

        var aa = a.wait();
        var bb = b.wait(aa);

        bb.yield(1, 2, 3);

        called0.isTrue();
    }


    @Test
    public function when_chaining_wait_then_yield__should_call_second_function_value_is_1() : Void {
        var called0 = 0;
        var called1 = 0;

        var a = function(value1, value2, value3) {
            called0 = value1;
        };
        var b = function(value1, value2, value3) {
            called1 = value1;
        };

        var aa = a.wait();
        var bb = b.wait(aa);

        bb.yield(1, 2, 3);

        called1.areEqual(1);
    }

    @Test
    public function when_chaining_wait_then_yield__should_call_first_function_value_is_1() : Void {
        var called0 = 0;
        var called1 = 0;

        var a = function(value1, value2, value3) {
            called0 = value1;
        };
        var b = function(value1, value2, value3) {
            called1 = value1;
        };

        var aa = a.wait();
        var bb = b.wait(aa);

        bb.yield(1, 2, 3);

        called1.areEqual(1);
    }
}
