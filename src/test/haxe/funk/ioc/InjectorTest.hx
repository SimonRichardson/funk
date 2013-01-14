package funk.ioc;

import funk.ioc.Injector;
import funk.types.Option;
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
}

class MockModule extends Module {

    public var configuredCalled : Bool;

    public function new() {
        super();

        configuredCalled = false;
    }

    override public function configure() {
        configuredCalled = true;
    }
}
