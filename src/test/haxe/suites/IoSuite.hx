package suites;

import massive.munit.TestSuite;

import funk.io.http.JsonLoaderTest;
import funk.io.http.UriLoaderTest;

import funk.io.logging.LogTest;

class IoSuite extends TestSuite {

    public function new() {
        super();

        #if net
        add(funk.io.http.JsonLoaderTest);
        add(funk.io.http.UriLoaderTest);
        #end

        add(funk.io.logging.LogTest);
    }
}
