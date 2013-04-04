package suites;

import massive.munit.TestSuite;

import funk.io.logging.LogTest;

class LoggingSuite extends TestSuite {

    public function new() {
        super();

        add(funk.io.logging.LogTest);
    }
}
