package funk.ioc;

import funk.ioc.Injector;
import funk.ioc.Inject;
import funk.ioc.Module;
import funk.types.Option;
import massive.munit.Assert;
import unit.Asserts;

using funk.types.extensions.Options;
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
}

@:keep
private class MockModule extends Module {

    public function new() {
        super();
    }

    override public function configure() {
        bind(String).toInstance("Hello");
        bind(MockSingleton).asSingleton();
    }
}

@:keep
private class MockObject {

    public var byInstance : String;

    public var bySingleton : MockSingleton;

    public function new() {
        byInstance = Inject.as(String).get();
        bySingleton = Inject.as(MockSingleton).get();
    }
}

@:keep
private class MockSingleton {

    public static var instances : Int = 0;

    public function new() {
        instances++;
    }
}
