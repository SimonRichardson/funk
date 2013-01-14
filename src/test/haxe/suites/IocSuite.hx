package suites;

import massive.munit.TestSuite;

import funk.ioc.BindingTest;
import funk.ioc.InjectorTest;
import funk.ioc.ModuleTest;

class IocSuite extends TestSuite
{

    public function new()
    {
        super();

        add(funk.ioc.BindingTest);
        add(funk.ioc.InjectorTest);
        add(funk.ioc.ModuleTest);
    }
}
