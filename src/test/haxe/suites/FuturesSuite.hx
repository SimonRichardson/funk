package suites;

import massive.munit.TestSuite;

import funk.futures.DeferredTest;
import funk.futures.PromiseTest;

class FuturesSuite extends TestSuite {

    public function new() {
        super();

        add(funk.futures.DeferredTest);
        add(funk.futures.PromiseTest);
    }
}
