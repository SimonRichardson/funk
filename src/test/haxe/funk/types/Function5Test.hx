package funk.types;

import funk.types.Function0;

using Type;
using funk.types.extensions.Functions5;
using funk.types.Tuple5;
using massive.munit.Assert;

class Function5Test {

    @Test
    public function when_calling__1__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3, value4, value5) {
            called = value1;
        };
        a._1(true)(false, false, false, false);
        called.isTrue();
    }

    @Test
    public function when_calling__2__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3, value4, value5) {
            called = value2;
        };
        a._2(true)(false, false, false, false);
        called.isTrue();
    }

    @Test
    public function when_calling__3__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3, value4, value5) {
            called = value3;
        };
        a._3(true)(false, false, false, false);
        called.isTrue();
    }

    @Test
    public function when_calling__4__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3, value4, value5) {
            called = value4;
        };
        a._4(true)(false, false, false, false);
        called.isTrue();
    }

    @Test
    public function when_calling__5__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3, value4, value5) {
            called = value5;
        };
        a._5(true)(false, false, false, false);
        called.isTrue();
    }

    @Test
    public function when_calling_compose__should_call_function_and_return_correct_response() : Void {
        var a = function(value) {
            return value;
        };

        var b = a.compose(function(value1, value2, value3, value4, value5){
            return value1 || value2 || value3 || value4 || value5;
        })(false, true, false, false, false);

        b.isTrue();
    }

    @Test
    public function when_calling_map__should_call_function() : Void {
        var a = function(value1, value2, value3, value4, value5) {
            return value1 || value2 || value3 || value4 || value5;
        };

        var b = a.map(function(value){
            return !!value;
        })(false, true, false, false, false);

        b.isTrue();
    }

    @Test
    public function when_calling_curry__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3, value4, value5) {
            called = true;
            return value1 || value2 || value3 || value4 || value5;
        };
        a.curry()(false)(true)(false)(false)(false);
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
        var a = function(value1, value2, value3, value4, value5) {
            return value1 || value2 || value3 || value4 || value5;
        }.untuple()(tuple5(false, true, false, false, false));
        a.isTrue();
    }

    @Test
    public function when_calling_untuple__should_call_function() : Void {
        var a = function(t : Tuple5<Bool, Bool, Bool, Bool, Bool>) {
            return t;
        }.tuple()(false, true, false, false, false);
        a.areEqual(tuple5(false, true, false, false, false));
    }
}
