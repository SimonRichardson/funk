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
    }

    @Test
    public function when_creating_an_object_via_getInstance_should_bind_correct_object() {
        var instance : Option<MockObject> = module.getInstance(MockObject);
        instance.get().byInstance.areEqual("Hello");
    }
}

private class MockModule extends Module {

    public function new() {
        super();
    }

    override public function configure() {
        bind(String).toInstance("Hello");
    }
}

@:keep
private class MockObject {

    public var byInstance : String;

    public function new() {
        byInstance = Inject.as(String).get();
    }
}
