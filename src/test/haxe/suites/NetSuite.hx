package suites;

import massive.munit.TestSuite;

import funk.net.UriTest;

class NetSuite extends TestSuite {

    public function new() {
        super();

        add(funk.net.UriTest);
    }
}
