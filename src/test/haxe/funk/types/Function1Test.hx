package funk.types;

using Type;
using funk.types.Function1;
using funk.types.Tuple1;
using massive.munit.Assert;

class Function1Test {

    @Test
    public function when_calling__1__should_call_function() : Void {
        var called = false;
        var a = function(value1) {
            called = value1;
        };
        a._1(true)();
        called.isTrue();
    }

    @Test
    public function when_calling_compose__should_call_function_and_return_correct_response() : Void {
        var a = function(value) {
            return value;
        };

        var b = a.compose(function(value){
            return !value;
        })(false);

        b.isTrue();
    }

    @Test
    public function when_calling_map__should_call_function() : Void {
        var a = function(value) {
            return value;
        };

        var b = a.map(function(value){
            return !value;
        })(false);

        b.isTrue();
    }

    @Test
    public function when_calling_curry__should_call_function() : Void {
        var called = false;
        var a = function(value) {
            called = true;
            return value;
        };
        a.curry()(true);
        called.isTrue();
    }

    @xTest
    public function when_calling_uncurry__should_call_function() : Void {
        var called = false;
        var a = function(value) {
            return function () {
                called = true;
                return value;
            }
        }.uncurry()(1);
        called.isTrue();
    }

    @Test
    public function when_calling_tuple__should_call_function() : Void {
        var a = function(value) {
            return value;
        }.untuple()(tuple1(true));
        a.isTrue();
    }

    @Test
    public function when_calling_untuple__should_call_function() : Void {
        var a = function(t : Tuple1<Bool>) {
            return t;
        }.tuple()(true);
        a.areEqual(tuple1(true));
    }
}
