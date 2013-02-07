package suites;

import massive.munit.TestSuite;

import funk.io.http.JsonpLoaderTest;
import funk.io.http.UriLoaderTest;

import funk.io.logging.LogTest;

class IoSuite extends TestSuite {

    public function new() {
        super();

        add(funk.io.http.UriLoaderTest);

        add(funk.io.logging.LogTest);

        #if js
        add(funk.io.http.JsonpLoaderTest);
        #end
    }
}
