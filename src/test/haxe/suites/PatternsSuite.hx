package suites;

import massive.munit.TestSuite;

import funk.patterns.mvc.ModelTest;

class PatternsSuite extends TestSuite {

    public function new() {
        super();

        add(funk.patterns.mvc.ModelTest);
    }
}
