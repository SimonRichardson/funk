package funk.ioc;

import funk.ioc.Injector;
import haxe.ds.Option;
import massive.munit.Assert;
import unit.Asserts;

using massive.munit.Assert;
using unit.Asserts;

class InjectorTest {

    @Before
    public function setup() {
        Injector.initialize();
    }

    @Test
    public function calling_currentScope_should_return_none() {
        Injector.currentScope().areEqual(None);
    }

    @Test
    public function calling_add_with_new_module_return_same_instance() {
        var instance = new Module();
        Injector.add(instance).areEqual(instance);
    }

    @Test
    public function calling_remove_with_new_module_return_same_instance() {
        var instance = new Module();
        Injector.remove(instance).areEqual(instance);
    }

    @Test
    public function calling_add_then_remove_with_new_module_return_same_instance() {
        var instance = new Module();
        Injector.add(instance);
        Injector.remove(instance).areEqual(instance);
    }

    @Test
    public function calling_add_with_new_module_calls_configure() {
        var instance = new MockModule();
        Injector.add(instance);
        instance.configuredCalled.isTrue();
    }

    @Test
    public function calling_push_scope_should_set_current_scope_to_instance() {
        var instance = new MockModule();
        Injector.pushScope(instance);
        Injector.currentScope().areEqual(Some(instance));
    }

    @Test
    public function calling_pop_scope_should_set_current_scope_to_None() {
        Injector.popScope();
        Injector.currentScope().areEqual(None);
    }

    @Test
    public function calling_push_and_pop_scope_should_set_current_scope_to_none() {
        var instance = new MockModule();
        Injector.pushScope(instance);
        Injector.popScope();
        Injector.currentScope().areEqual(None);
    }

    @Test
    public function calling_push_twice_and_pop_scope_should_set_current_scope_to_instance() {
        var instance = new MockModule();
        Injector.pushScope(instance);
        Injector.pushScope(new MockModule());
        Injector.popScope();
        Injector.currentScope().areEqual(Some(instance));
    }

    @Test
    public function calling_push_thrice_and_pop_scope_should_set_current_scope_to_instance() {
        var instance = new MockModule();
        Injector.pushScope(new MockModule());
        Injector.pushScope(instance);
        Injector.pushScope(new MockModule());
        Injector.popScope();
        Injector.currentScope().areEqual(Some(instance));
    }

    @Test
    public function calling_scopeOf_with_no_prepared_modules_returns_none() {
        Injector.scopeOf(String).areEqual(None);
    }

    @Test
    public function calling_scopeOf_with_prepared_modules_returns_instance() {
        var instance = new MockModule();
        Injector.add(instance);
        Injector.scopeOf(String).areEqual(Some(instance));
    }

    @Test
    public function calling_scopeOf_with_prepared_modules_returns_error_if_binding_same_object() {
        var instance = new MockModule();
        Injector.add(instance);
        Injector.add(new MockModule());

        var called = try {
            Injector.scopeOf(String).areEqual(Some(instance));
            false;
        } catch (error : Dynamic) {
            true;
        }
    }

    @Test
    public function calling_moduleOf_with_no_prepared_modules_return_none() {
        Injector.moduleOf(String).areEqual(None);
    }

    @Test
    public function calling_moduleOf_with_invalid_prepared_modules_should_return_None() {
        var instance = new MockModule();
        Injector.add(instance);
        Injector.moduleOf(String).areEqual(None);
    }

    @Test
    public function calling_moduleOf_with_prepared_modules_should_return_same_object() {
        var instance = new MockModule();
        Injector.add(instance);
        Injector.moduleOf(MockModule).areEqual(Some(instance));
    }

    @Test
    public function calling_moduleOf_with_two_prepared_modules_should_return_same_object() {
        var instance = new MockModule();
        Injector.add(new MockModule());
        Injector.add(instance);
        Injector.moduleOf(MockModule);
        Injector.moduleOf(MockModule).areEqual(Some(instance));
    }
}

@:keep
private class MockModule extends Module {

    public var configuredCalled : Bool;

    public function new() {
        super();

        configuredCalled = false;
    }

    override public function configure() {
        configuredCalled = true;

        bind(String).toInstance("Hello");
    }
}
