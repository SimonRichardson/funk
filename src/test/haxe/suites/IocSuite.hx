package suites;

import massive.munit.TestSuite;

import funk.ioc.InjectTest;

class IocSuite extends TestSuite
{

    public function new()
    {
        super();

        add(funk.ioc.InjectTest);
    }
}
