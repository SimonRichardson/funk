package funk.ioc;

import funk.ioc.Injector;
import funk.ioc.Inject;
import funk.ioc.Module;
import funk.types.Any;

using funk.ds.immutable.List;
using funk.types.Option;
using massive.munit.Assert;
using unit.Asserts;

class InjectTest {

    private var module : IModule;

    @Before
    public function setup() {
        Injector.initialize();
        module = Injector.add(new MockModule());

        MockSingleton.instances = 0;
    }

    @Test
    public function when_creating_an_object_via_getInstance_should_bind_correct_object() {
        var instance : Option<MockObject> = module.getInstance(MockObject);
        instance.get().byInstance.areEqual("Hello");
    }

    @Test
    public function when_creating_multiple_objects_with_a_singleton_should_have_one_instance() {
        var instance0 : Option<MockObject> = module.getInstance(MockObject);
        var instance1 : Option<MockObject> = module.getInstance(MockObject);
        var instance2 : Option<MockObject> = module.getInstance(MockObject);
        var instance3 : Option<MockObject> = module.getInstance(MockObject);

        MockSingleton.instances.areEqual(1);
    }

    @Test
    public function when_creating_an_object_by_interface_should_not_be_null() {
        var instance : Option<MockObject> = module.getInstance(MockObject);
        instance.get().byInterface.isNotNull();
    }

    @Test
    public function when_creating_an_object_by_interface_should_return_correct_interface() {
        var instance : Option<MockObject> = module.getInstance(MockObject);
        AnyTypes.isInstanceOf(instance.get().byInterface, IAnotherObject).isTrue();
    }

    @Test
    public function when_creating_an_object_by_interface_should_return_correct_object() {
        var instance : Option<MockObject> = module.getInstance(MockObject);
        AnyTypes.isInstanceOf(instance.get().byInterface, AnotherObject).isTrue();
    }

    @Test
    public function when_creating_an_object_by_interface_should_return_correct_object_and_return_string() {
        var instance : Option<MockObject> = module.getInstance(MockObject);
        instance.get().byInterface.hello().areEqual("World!");
    }

    @Test
    public function with_null_passed_as_first_param_should_throw_error() {
        var instance : Option<MockObject> = module.getInstance(MockObject);

        var called = try {
            Inject.withIn(null, MockModule);
            false;
        } catch (error : Dynamic) {
            true;
        }

        called.isTrue();
    }

    @Test
    public function with_null_passed_as_first_param_for_inject_should_throw_error() {
         var called = try {
            Inject.as(null);
            false;
        } catch (error : Dynamic) {
            true;
        }

        called.isTrue();
    }

    @Test
    public function with_null_passed_as_second_param_should_throw_error() {
        var instance : Option<MockObject> = module.getInstance(MockObject);

        var called = try {
            Inject.withIn(IAnotherObject, null);
            false;
        } catch (error : Dynamic) {
            true;
        }

        called.isTrue();
    }

    @Test
    public function when_inject_withIn_should_not_be_null() {
        var instance : Option<MockObject> = module.getInstance(MockObject);
        Inject.withIn(IAnotherObject, MockModule).get().isNotNull();
    }

    @Test
    public function when_inject_withIn_should_be_instance_of_correct_object() {
        var instance : Option<MockObject> = module.getInstance(MockObject);
        AnyTypes.isInstanceOf(Inject.withIn(IAnotherObject, MockModule).get(), IAnotherObject).isTrue();
    }

    @Test
    public function when_injecting_into_a_module_with_an_interface() {
        Injector.add(new GeneralModule());
        AnyTypes.isInstanceOf(Inject.as(Renderer).get(), HtmlDomRenderer).isTrue();
    }

    @Test
    public function when_doing_nesting_injection() {
        Injector.add(new GeneralModule());
        Injector.add(new OtherModule());
        AnyTypes.isInstanceOf(Inject.as(Other).get(), Other).isTrue();
    }
}

private class GeneralModule extends Module {

    public function new() {
        super();
    }

    override public function configure() {
        bind(Renderer).to(HtmlDomRenderer);
    }
}

private class OtherModule extends Module {

    public function new() {
        super();
    }

    override public function configure() {
        bind(Other);
    }
}

private interface Renderer<T> {

    function addChildren(name : String, nodes : List<T>) : Void;

    function removeChildren(name : String) : Void;
}

private class HtmlDomRenderer implements Renderer<String> {

    public function new() {

    }

    public function addChildren(name : String, nodes : List<String>) : Void {
    }

    public function removeChildren(name : String) : Void {
    }
}

private class Other {

    private var _renderer : Renderer<String>;

    public function new() {
        _renderer = cast Inject.as(Renderer).get();
    }
}

@:keep
private class MockModule extends Module {

    public function new() {
        super();
    }

    override public function configure() {
        bind(String).toInstance("Hello");
        bind(IAnotherObject).to(AnotherObject);
        bind(MockSingleton).asSingleton();
        bind(MockObject);
    }
}

@:keep
private class MockObject {

    public var byInstance : String;

    public var bySingleton : MockSingleton;

    public var byInterface : IAnotherObject;

    public function new() {
        byInstance = Inject.as(String).get();
        bySingleton = Inject.as(MockSingleton).get();
        byInterface = Inject.as(IAnotherObject).get();
    }
}

@:keep
private class MockSingleton {

    public static var instances : Int = 0;

    public function new() {
        instances++;
    }
}

@:keep
private interface IAnotherObject {

    function hello() : String;
}

@:keep
private class AnotherObject implements IAnotherObject {

    public function new() {

    }

    public function hello() : String {
        return "World!";
    }
}
