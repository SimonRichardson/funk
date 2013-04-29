package funk.types;

using Type;
using funk.types.Function0;
using massive.munit.Assert;

class Function0Test {

    @Test
    public function when_calling__0__should_call_function() : Void {
        var called = false;
        var a = function() {
            called = true;
        };
        a._0()();
        called.isTrue();
    }

    @Test
    public function when_calling_map__should_call_function() : Void {
        var called = false;
        var a = function() { return true; };
        a.map(function(value : Bool) {
            called = true;
            return false;
        })();
        called.isTrue();
    }

    @Test
    public function when_calling_map__should_map_function() : Void {
        var a = function() { return false; };
        var value = a.map(function(value : Bool) {
            return !value;
        })();
        value.isTrue();
    }

    @xTest
    public function when_calling_flatMap__should_call_function() : Void {
        var a = function() { return false; };

        a.flatMap(function(value) {
            return function() {
                return !value;
            };
        })();
    }

    @Test
    public function when_calling_promote__should_call_function() : Void {
        var called = false;
        var a = function() {
            called = true;
        };

        a.promote()(true);
        called.isTrue();
    }

    @Test
    public function when_calling_lazy__should_return_value() : Void {
        var instance = {};
        function() {
            return instance;
        }.lazy()().areEqual(instance);
    }

    @Test
    public function when_calling_lazy_twice__should_return_same_value() : Void {
        var instance = {};
        var lax = function() {
            return instance;
        };
        lax.lazy()();
        lax.lazy()().areEqual(instance);
    }

    @Test
    public function when_calling_lazy_twice__should_return_same_instance() : Void {
        var lax = function() {
            return {};
        }.lazy();
        lax().areEqual(lax());
    }

    @Test
    public function when_calling_lazy_twice__should_be_called_once() : Void {
        var amount = 0;
        var lax = function() {
            amount++;
            return {};
        }.lazy();
        lax();
        lax();
        amount.areEqual(1);
    }

    @Test
    public function when_effectOf_is_called_should_be_called_correctly() : Void {
        var called = false;
        var effect = function() {
            called = true;
            return 1;
        }.effectOf();
        effect();
        called.isTrue();
    }
}
