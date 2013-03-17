package funk.ioc;

import funk.ioc.Injector;

using funk.types.extensions.Strings;
using massive.munit.Assert;
using unit.Asserts;
using funk.ioc.BindingTest.Strings;

class Strings {

    public static function unbox(value : String) : String {
        return value.toString();
    }
}

class BindingTest {

    private var module : Module;

    @Before
    public function setup() {
        module = new Module();

        Injector.initialize();
        Injector.add(module);
    }

    @After
    public function tearDown() {
        Injector.remove(module);
    }

    @Test
    public function create_new_binding_should_not_throw_error() {
        var binding = new Binding(new Module());
        binding.isNotNull();
    }

    @Test
    public function create_new_binding_should_throw_error_if_module_is_null() {
        var called = try {
            new Binding(null);
            false;
        } catch (error : Dynamic) {
            true;
        }

        called.isTrue();
    }

    @Test
    public function binding_with_to_with_null_should_throw_Error() {
        var binding = new Binding(new Module());

        var called = try {
            binding.to(null);
            false;
        } catch (error : Dynamic) {
            true;
        }

        called.isTrue();
    }

    @Test
    public function binding_with_to_should_return_a_scope() {
        var binding = new Binding(new Module());
        binding.to(String).areEqual(binding);
    }

    @Test
    public function binding_with_to_and_calling_getInstance_should_return_now_string() {
        var binding = new Binding(module);
        binding.to(String);
        binding.getInstance().areEqual(new String("").unbox());
    }

    @Test
    public function binding_with_to_and_calling_getInstance_asSingleton_should_return_provided_object() {
        var binding = new Binding(module);
        binding.to(Array).asSingleton();

        var instance = binding.getInstance();
        binding.getInstance().areEqual(instance);
    }

    @Test
    public function binding_with_toInstance_with_null_should_throw_Error() {
        var binding = new Binding(new Module());

        var called = try {
            binding.toInstance(null);
            false;
        } catch (error : Dynamic) {
            true;
        }

        called.isTrue();
    }

    @Test
    public function binding_with_toInstance_should_return_a_scope() {
        var binding = new Binding(new Module());
        binding.toInstance(String).areEqual(binding);
    }

    @Test
    public function binding_with_toInstance_and_calling_getInstance_should_return_same_instance() {
        var instance = Date.now();
        var binding = new Binding(module);
        binding.toInstance(instance);
        binding.getInstance().areEqual(instance);
    }

    @Test
    public function binding_with_toInstance_and_calling_getInstance_asSingleton_should_return_provided_object() {
        var binding = new Binding(module);
        binding.toInstance(Date.now()).asSingleton();

        var instance = binding.getInstance();
        binding.getInstance().areEqual(instance);
    }

    @Test
    public function binding_with_toProvider_with_null_should_throw_Error() {
        var binding = new Binding(new Module());

        var called = try {
            binding.toProvider(null);
            false;
        } catch (error : Dynamic) {
            true;
        }

        called.isTrue();
    }

    @Test
    public function binding_with_toProvider_should_return_a_scope() {
        var binding = new Binding(new Module());
        binding.toProvider(MockProvider).areEqual(binding);
    }

    @Test
    public function binding_with_toProvider_and_calling_getInstance_should_return_provided_object() {
        MockProvider.instance = new MockObject();

        var binding = new Binding(module);
        binding.toProvider(MockProvider);
        Assert.areEqual(binding.getInstance(), MockProvider.instance);
    }

    @Test
    public function binding_with_toProvider_and_calling_getInstance_asSingleton_should_return_provided_object() {
        var binding = new Binding(module);
        binding.toProvider(MockProvider).asSingleton();

        MockProvider.instance = new MockObject();

        var instance : MockObject = binding.getInstance();

        MockProvider.instance = new MockObject();

        binding.getInstance().areEqual(instance);
    }

}

@:keep
private class MockProvider {

    public static var instance : MockObject;

    public function new() {
    }

    public function get() : MockObject {
        return cast MockProvider.instance;
    }
}

@:keep
private class MockObject {

    public function new() {

    }
}
