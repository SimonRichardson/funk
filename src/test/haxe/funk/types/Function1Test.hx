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

    @Test
    public function when_calling_lazy__should_return_value() : Void {
        var instance = Math.random();
        function(a) {
            return instance + a;
        }.lazy(1)().areEqual(instance + 1);
    }

    @Test
    public function when_calling_lazy_twice__should_return_same_value() : Void {
        var instance = Math.random();
        var lax = function(a) {
            return instance + a;
        };
        lax.lazy(1)();
        lax.lazy(1)().areEqual(instance + 1);
    }

    @Test
    public function when_calling_lazy_twice__should_return_same_instance() : Void {
        var lax = function(a) {
            return Math.random();
        }.lazy(1);
        lax().areEqual(lax());
    }

    @Test
    public function when_calling_lazy_twice__should_be_called_once() : Void {
        var amount = 0;
        var lax = function(a) {
            amount++;
            return {};
        }.lazy(1);
        lax();
        lax();
        amount.areEqual(1);
    }

    @Test
    public function when_effectOf_is_called_should_be_called_correctly() : Void {
        var called = false;
        var effect = function(a) {
            called = true;
            return 1;
        }.effectOf();
        effect(1);
        called.isTrue();
    }
}
