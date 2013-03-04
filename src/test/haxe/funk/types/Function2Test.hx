package funk.types;

import Type;
import funk.types.Function0;
import funk.types.Tuple2;
import funk.types.extensions.Functions2;
import funk.types.extensions.Tuples2;
import massive.munit.Assert;

using Type;
using funk.types.extensions.Functions2;
using funk.types.extensions.Tuples2;
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
}
