package funk.ioc;

import funk.ioc.Injector;
import funk.types.Any;

using funk.types.Option;
using massive.munit.Assert;
using unit.Asserts;

class ModuleTest {

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
    public function when_creating_new_module_should_not_throw_error() {
        new Module().isNotNull();
    }

    @Test
    public function when_creating_new_module_initialize_should_not_throw_error() {
        var module = new Module();
        module.initialize();
        module.isNotNull();
    }

    @Test
    public function when_creating_new_module_configure_should_not_throw_error() {
        var module = new Module();
        module.configure();
        module.isNotNull();
    }

    @Test
    public function when_creating_new_module_with_getInstance_without_initialize_should_throw_error() {
        var called = try {
            new Module().getInstance(Date);
            false;
        } catch (error : Dynamic) {
            true;
        }
        called.isTrue();
    }

    @Test
    public function when_creating_new_module_calling_getInstance_should_return_valid_option() {
        module.getInstance(String).areEqual(None);
    }

    @Test
    public function when_creating_new_module_calling_bind_return_not_null() {
        module.bind(String).isNotNull();
    }

    @Test
    public function when_creating_new_module_calling_bind_return_binding() {
        Assert.isTrue(AnyTypes.isInstanceOf(module.bind(String), Binding));
    }

    @Test
    public function when_creating_new_module_calling_bind_with_same_type_twice_should_throw_error() {
        module.bind(String);
        var called = try {
            module.bind(String);
            false;
        } catch (error : Dynamic) {
            true;
        }

        called.isTrue();
    }

    @Test
    public function when_adding_a_bindable_should_calling_binds_be_true() {
        module.bind(String);
        module.binds(String).isTrue();
    }

    @Test
    public function when_adding_a_bindable_should_calling_another_binds_be_false() {
        module.bind(String);
        module.binds(Empty1).isFalse();
    }

    @Test
    public function when_creating_new_module_calling_bind_then_getInstance_should_return_valid_option() {
        module.bind(String);
        module.getInstance(String).areEqual(Some(""));
    }

    @Test
    public function when_adding_multiple_bindables_should_calling_another_binds_be_false() {
        module.bind(String);
        module.bind(Empty1);
        module.binds(Empty2).isFalse();
    }
}

private class Empty1 {
}

private class Empty2 {
}
