package funk.types;

using Type;
using funk.types.Function3;
using funk.types.Tuple3;
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
}
