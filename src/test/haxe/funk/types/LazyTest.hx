package funk.types;

using Type;
using funk.types.Lazy;
using massive.munit.Assert;

class LazyTest {

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
}
