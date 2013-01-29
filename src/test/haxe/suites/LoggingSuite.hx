package suites;

import massive.munit.TestSuite;

import funk.logging.LogTest;

class LoggingSuite extends TestSuite {

    public function new() {
        super();

        add(funk.logging.LogTest);
    }
}
