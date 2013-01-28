package suites;

import massive.munit.TestSuite;

import funk.ioc.BindingTest;
import funk.ioc.InjectorTest;
import funk.ioc.InjectTest;
import funk.ioc.ModuleTest;
import funk.ioc.types.TypesTest;

class IocSuite extends TestSuite
{

    public function new()
    {
        super();

        add(funk.ioc.BindingTest);
        add(funk.ioc.InjectorTest);
        add(funk.ioc.InjectTest);
        add(funk.ioc.ModuleTest);

        add(funk.ioc.types.TypesTest);
    }
}
